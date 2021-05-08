# frozen_string_literal: true

RSpec.describe 'register_block/vhdl_top' do
  include_context 'vhdl common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:address_width, :bus_width])
    RgGen.enable(:register_block, [:name, :byte_size])
    RgGen.enable(:register_file, [:name, :offset_address, :size])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :type, :initial_value])
    RgGen.enable(:bit_field, :type, [:rw])
    RgGen.enable(:register_block, :vhdl_top)
    RgGen.enable(:register_file, :vhdl_top)
    RgGen.enable(:register, :vhdl_top)
    RgGen.enable(:bit_field, :vhdl_top)
  end

  def create_register_block(&body)
    create_vhdl(&body).register_blocks.first
  end

  let(:bus_width) { default_configuration.bus_width }

  let(:address_width) { 8 }

  describe 'clock/reset' do
    it 'clock/resetを持つ' do
      register_block = create_register_block { name 'block_0'; byte_size 256 }
      expect(register_block).to have_port(
        :clock,
        name: 'i_clk', direction: :in
      )
      expect(register_block).to have_port(
        :reset,
        name: 'i_rst_n', direction: :in
      )
    end
  end

  describe 'レジスタアクセス' do
    def check_register_signals(register_block, array_size, value_width)
      expect(register_block).to have_signal(:register_valid)
      expect(register_block).to have_signal(:register_access, width: 2)
      expect(register_block).to have_signal(:register_address, width: address_width)
      expect(register_block).to have_signal(:register_write_data, width: bus_width)
      expect(register_block).to have_signal(:register_strobe, width: bus_width / 8)
      expect(register_block).to have_signal(:register_active, array_size: [array_size])
      expect(register_block).to have_signal(:register_ready, array_size: [array_size])
      expect(register_block).to have_signal(:register_status, width: 2, array_size: [array_size])
      expect(register_block).to have_signal(:register_read_data, width: bus_width, array_size: [array_size])
      expect(register_block).to have_signal(:register_value, width: value_width, array_size: [array_size])
    end

    it 'レジスタアクセス用の信号群を持つ' do
      register_block = create_register_block do
        name 'block_0'
        byte_size 256
        register do
          name 'register_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end
      end
      check_register_signals(register_block, 1, bus_width)

      register_block = create_register_block do
        name 'block_0'
        byte_size 256
        register do
          name 'register_0'
          offset_address 0x00
          size [2, 4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end
      end
      check_register_signals(register_block, 8, bus_width)

      register_block = create_register_block do
        name 'block_0'
        byte_size 256
        register do
          name 'register_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end
        register do
          name 'register_1'
          offset_address 0x10
          bit_field { name 'bit_field_0'; bit_assignment lsb: 32; type :rw; initial_value 0 }
        end
        register do
          name 'register_2'
          offset_address 0x20
          bit_field { name 'bit_field_0'; bit_assignment lsb: 64; type :rw; initial_value 0 }
        end
      end
      check_register_signals(register_block, 3, 3 * bus_width)

      register_block = create_register_block do
        name 'block_0'
        byte_size 256

        register_file do
          name 'register_file_0'
          register do
            name 'register_0'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          end
          register do
            name 'register_1'
            size [2, 2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 32; type :rw; initial_value 0 }
          end
        end

        register_file do
          name 'register_file_1'
          size [2, 2]
          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
            end
            register do
              name 'register_1'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 32; type :rw; initial_value 0 }
            end
          end
        end
      end
      check_register_signals(register_block, 25, 2 * bus_width)
    end
  end
end
