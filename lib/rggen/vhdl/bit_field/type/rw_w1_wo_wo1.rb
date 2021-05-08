# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:rw, :w1, :wo, :wo1]) do
  vhdl do
    build do
      output :value_out, {
        name: "o_#{full_name}", width: width, array_size: array_size
      }
    end

    main_code :bit_field, from_template: true

    private

    def read_action
      bit_field.readable? && 'RGGEN_READ_DEFAULT' || 'RGGEN_READ_NONE'
    end

    def write_once
      [:w1, :wo1].include?(bit_field.type)
    end
  end
end
