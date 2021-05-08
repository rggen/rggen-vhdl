# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, :ro) do
  vhdl do
    build do
      unless bit_field.reference?
        input :value_in, {
          name: "i_#{full_name}", width: width, array_size: array_size
        }
      end
    end

    main_code :bit_field, from_template: true

    private

    def reference_or_value_in
      bit_field.reference? && reference_bit_field || value_in[loop_variables]
    end
  end
end
