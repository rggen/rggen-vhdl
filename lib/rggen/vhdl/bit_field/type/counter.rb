# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, :counter) do
  vhdl do
    build do
      generic :up_width, {
        name: "#{full_name}_up_width".upcase, type: :natural, default: 1
      }
      generic :down_width, {
        name: "#{full_name}_down_width".upcase, type: :natural, default: 1
      }
      generic :wrap_around, {
        name: "#{full_name}_wrap_around".upcase, type: :boolean, default: false
      }
      if external_clear?
        generic :use_clear, {
          name: "#{full_name}_use_clear".upcase, type: :boolean, default: true
        }
      end

      input :up, {
        name: "i_#{full_name}_up",
        width: "clip_width(#{up_width})", array_size:
      }
      input :down, {
        name: "i_#{full_name}_down",
        width: "clip_width(#{down_width})", array_size:
      }
      if external_clear?
        input :clear, {
          name: "i_#{full_name}_clear", width: 1, array_size:
        }
      end
      output :count, {
        name: "o_#{full_name}", width:, array_size:
      }
    end

    main_code :bit_field, from_template: true

    private

    def external_clear?
      !bit_field.reference?
    end

    def use_clear_value
      !external_clear? || use_clear
    end

    def clear_signal
      reference_bit_field || clear[loop_variables]
    end
  end
end
