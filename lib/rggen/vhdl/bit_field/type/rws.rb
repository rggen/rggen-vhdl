# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, :rws) do
  vhdl do
    build do
      unless bit_field.reference?
        input :set, {
          name: "i_#{full_name}_set", width: 1, array_size: array_size
        }
      end
      input :value_in, {
        name: "i_#{full_name}", width: width, array_size: array_size
      }
      output :value_out, {
        name: "o_#{full_name}", width: width, array_size: array_size
      }
    end

    main_code :bit_field, from_template: true

    private

    def set_signal
      reference_bit_field || set[loop_variables]
    end
  end
end
