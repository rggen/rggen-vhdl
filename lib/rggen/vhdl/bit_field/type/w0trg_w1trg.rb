# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:w0trg, :w1trg]) do
  vhdl do
    build do
      output :trigger, {
        name: "o_#{full_name}_trigger", width:, array_size:
      }
    end

    main_code :bit_field, from_template: true

    private

    def write_one_trigger?
      bit_field.type == :w1trg
    end
  end
end
