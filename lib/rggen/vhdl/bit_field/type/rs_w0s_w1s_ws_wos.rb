# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:rs, :w0s, :w1s, :ws, :wos]) do
  vhdl do
    build do
      input :clear, {
        name: "i_#{full_name}_clear", width: width, array_size: array_size
      }
      output :value_out, {
        name: "o_#{full_name}", width: width, array_size: array_size
      }
    end

    main_code :bit_field, from_template: true

    private

    def read_action
      {
        rs: 'RGGEN_READ_SET',
        w0s: 'RGGEN_READ_DEFAULT',
        w1s: 'RGGEN_READ_DEFAULT',
        ws: 'RGGEN_READ_DEFAULT',
        wos: 'RGGEN_READ_NONE'
      }[bit_field.type]
    end

    def write_action
      {
        rs: 'RGGEN_WRITE_NONE',
        w0s: 'RGGEN_WRITE_0_SET',
        w1s: 'RGGEN_WRITE_1_SET',
        ws: 'RGGEN_WRITE_SET',
        wos: 'RGGEN_WRITE_SET'
      }[bit_field.type]
    end

    def write_enable
      bit_field.writable? && bin(1, 1) || bin(0, 1)
    end
  end
end
