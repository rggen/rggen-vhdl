# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:ro, :rotrg]) do
  vhdl do
    build do
      unless bit_field.reference?
        input :value_in, {
          name: "i_#{full_name}", width: width, array_size: array_size
        }
      end
      if rotrg?
        output :read_trigger, {
          name: "o_#{full_name}_read_trigger", width: 1, array_size: array_size
        }
      end
    end

    main_code :bit_field, from_template: true

    private

    def rotrg?
      bit_field.type == :rotrg
    end

    def read_trigger_signal
      rotrg? && read_trigger[loop_variables] || 'open'
    end

    def reference_or_value_in
      reference_bit_field || value_in[loop_variables]
    end
  end
end
