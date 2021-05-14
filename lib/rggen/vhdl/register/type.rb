# frozen_string_literal: true

RgGen.define_list_feature(:register, :type) do
  vhdl do
    base_feature do
      include RgGen::SystemVerilog::RTL::RegisterType

      private

      def readable?
        register.readable?
      end

      def writable?
        register.writable?
      end

      def clock
        register_block.clock
      end

      def reset
        register_block.reset
      end

      def register_valid
        register_block.register_valid
      end

      def register_access
        register_block.register_access
      end

      def register_address
        register_block.register_address
      end

      def register_write_data
        register_block.register_write_data
      end

      def register_strobe
        register_block.register_strobe
      end

      def register_active
        register_block.register_active[[register.index]]
      end

      def register_ready
        register_block.register_ready[[register.index]]
      end

      def register_status
        register_block.register_status[[register.index]]
      end

      def register_read_data
        register_block.register_read_data[[register.index]]
      end

      def register_value
        register_block.register_value[[register.index], 0, width]
      end

      def bit_field_valid
        register.bit_field_valid
      end

      def bit_field_read_mask
        register.bit_field_read_mask
      end

      def bit_field_write_mask
        register.bit_field_write_mask
      end

      def bit_field_write_data
        register.bit_field_write_data
      end

      def bit_field_read_data
        register.bit_field_read_data
      end

      def bit_field_value
        register.bit_field_value
      end
    end

    default_feature do
      main_code :register, from_template: File.join(__dir__, 'type', 'default.erb')
    end

    factory do
      def target_feature_key(_configuration, register)
        type = register.type
        valid_type?(type) && type ||
          (error "code generator for #{type} register type is not implemented")
      end

      private

      def valid_type?(type)
        target_features.key?(type) || type == :default
      end
    end
  end
end
