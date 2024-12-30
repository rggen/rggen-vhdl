# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, :rohw) do
  vhdl do
    build do
      unless bit_field.reference?
        input :valid, {
          name: "i_#{full_name}_valid", width: 1, array_size:
        }
      end
      input :value_in, {
        name: "i_#{full_name}", width:, array_size:
      }
      output :value_out, {
        name: "o_#{full_name}", width:, array_size:
      }
    end

    main_code :bit_field, from_template: true

    private

    def valid_signal
      reference_bit_field || valid[loop_variables]
    end
  end
end
