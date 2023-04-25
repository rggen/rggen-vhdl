# frozen_string_literal: true

RgGen.define_list_feature(:register_block, :protocol) do
  vhdl do
    shared_context.feature_registry(registry)

    base_feature do
      build do
        generic :address_width, {
          name: 'ADDRESS_WIDTH', type: :positive, default: local_address_width
        }
        generic :pre_decode, {
          name: 'PRE_DECODE', type: :boolean, default: false
        }
        generic :base_address, {
          name: 'BASE_ADDRESS', default: hex(0, 4)
        }
        generic :error_status, {
          name: 'ERROR_STATUS', type: :boolean, default: false
        }
        generic :insert_slicer, {
          name: 'INSERT_SLICER', type: :boolean, default: false
        }
      end

      private

      def bus_width
        configuration.bus_width
      end

      def local_address_width
        register_block.local_address_width
      end

      def total_registers
        register_block.files_and_registers.sum(&:count)
      end

      def byte_size
        register_block.byte_size
      end
    end

    factory do
      def target_feature_key(configuration, _register_block)
        configuration.protocol
      end
    end
  end
end
