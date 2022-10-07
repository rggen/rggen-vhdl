# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, :custom) do
  vhdl do
    build do
      if external_read_data?
        input :value_in, {
          name: "i_#{full_name}", width: width, array_size: array_size
        }
      else
        output :value_out, {
          name: "o_#{full_name}", width: width, array_size: array_size
        }
      end
      if bit_field.hw_write?
        input :hw_write_enable, {
          name: "i_#{full_name}_hw_write_enable", width: 1, array_size: array_size
        }
        input :hw_write_data, {
          name: "i_#{full_name}_hw_write_data", width: width, array_size: array_size
        }
      end
      if bit_field.hw_set?
        input :hw_set, {
          name: "i_#{full_name}_hw_set", width: width, array_size: array_size
        }
      end
      if bit_field.hw_clear?
        input :hw_clear, {
          name: "i_#{full_name}_hw_clear", width: width, array_size: array_size
        }
      end
      if bit_field.write_trigger?
        output :write_trigger, {
          name: "o_#{full_name}_write_trigger", width: 1, array_size: array_size
        }
      end
      if bit_field.read_trigger?
        output :read_trigger, {
          name: "o_#{full_name}_read_trigger", width: 1, array_size: array_size
        }
      end
    end

    main_code :bit_field, from_template: true

    private

    def external_read_data?
      !bit_field.sw_update? && !bit_field.hw_update?
    end

    def initial_value
      external_read_data? && default_initial_value || super
    end

    def default_initial_value
      value = hex(0, width)
      "slice(#{value}, #{width}, 0)"
    end

    def sw_read_action
      {
        none: 'RGGEN_READ_NONE',
        default: 'RGGEN_READ_DEFAULT',
        set: 'RGGEN_READ_SET',
        clear: 'RGGEN_READ_CLEAR'
      }[bit_field.sw_read]
    end

    def sw_write_action
      {
        none: 'RGGEN_WRITE_NONE',
        default: 'RGGEN_WRITE_DEFAULT',
        clear_0: 'RGGEN_WRITE_0_CLEAR',
        clear_1: 'RGGEN_WRITE_1_CLEAR',
        clear: 'RGGEN_WRITE_CLEAR',
        set_0: 'RGGEN_WRITE_0_SET',
        set_1: 'RGGEN_WRITE_1_SET',
        set: 'RGGEN_WRITE_SET',
        toggle_0: 'RGGEN_WRITE_0_TOGGLE',
        toggle_1: 'RGGEN_WRITE_1_TOGGLE'
      }[bit_field.sw_write]
    end

    def storage?
      !external_read_data?
    end

    def trigger?
      bit_field.write_trigger? || bit_field.read_trigger?
    end

    def input_port(name, default = nil)
      find_port(name, default || '(others => \'0\')')
    end

    def output_port(name)
      find_port(name, 'open')
    end

    def find_port(name, default_value)
      respond_to?(name) && __send__(name)[loop_variables] || default_value
    end
  end
end
