# frozen_string_literal: true

RgGen.define_list_feature(:bit_field, :type) do
  vhdl do
    base_feature do
      private

      def library_name
        configuration.library_name
      end

      def full_name
        bit_field.full_name('_')
      end

      def lsb
        bit_field.lsb(bit_field.local_index)
      end

      def width
        bit_field.width
      end

      def array_size
        bit_field.array_size
      end

      def initial_value
        index = bit_field.initial_value_array? && bit_field.flat_loop_index || 0
        "slice(#{bit_field.initial_value}, #{width}, #{index})"
      end

      def clock
        register_block.clock
      end

      def reset
        register_block.reset
      end

      def bit_field_read_valid
        register.bit_field_read_valid
      end

      def bit_field_write_valid
        register.bit_field_write_valid
      end

      def bit_field_mask
        register.bit_field_mask[lsb, width]
      end

      def bit_field_write_data
        register.bit_field_write_data[lsb, width]
      end

      def bit_field_read_data
        register.bit_field_read_data[lsb, width]
      end

      def bit_field_value
        register.bit_field_value[lsb, width]
      end

      def mask
        reference_bit_field || "(others => '1')"
      end

      def reference_bit_field
        bit_field.reference? &&
          bit_field
            .find_reference(register_block.bit_fields)
            .value(bit_field.local_indexes, bit_field.reference_width)
      end

      def loop_variables
        bit_field.loop_variables
      end
    end

    factory do
      def target_feature_key(_configuration, bit_field)
        type = bit_field.type
        target_features.key?(type) && type ||
          (error "code generator for #{type} bit field type is not implemented")
      end
    end
  end
end
