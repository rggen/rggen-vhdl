# frozen_string_literal: true

RgGen.define_simple_feature(:register_block, :vhdl_top) do
  vhdl do
    build do
      input :clock, { name: 'i_clk' }
      input :reset, { name: 'i_rst_n' }

      signal :register_valid
      signal :register_access, {
        width: 2
      }
      signal :register_address, {
        width: address_width
      }
      signal :register_write_data, {
        width: bus_width
      }
      signal :register_strobe, {
        width: bus_width / 8
      }
      signal :register_active, {
        array_size: [total_registers]
      }
      signal :register_ready, {
        array_size: [total_registers]
      }
      signal :register_status, {
        width: 2, array_size: [total_registers]
      }
      signal :register_read_data, {
        width: bus_width, array_size: [total_registers]
      }
      signal :register_value, {
        width: value_width, array_size: [total_registers]
      }
    end

    private

    def total_registers
      register_block.files_and_registers.sum(&:count)
    end

    def address_width
      register_block.local_address_width
    end

    def bus_width
      configuration.bus_width
    end

    def value_width
      register_block.registers.map(&:width).max
    end
  end
end
