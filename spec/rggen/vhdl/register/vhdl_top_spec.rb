# frozen_string_literal: true

RSpec.describe 'register/vhdl_top' do
  include_context 'vhdl common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width])
    RgGen.enable(:register_block, [:name, :byte_size])
    RgGen.enable(:register_file, [:name, :offset_address, :size])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:register, :type, [:external, :indirect])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :type, :initial_value, :reference])
    RgGen.enable(:bit_field, :type, :rw)
    RgGen.enable(:register_block, :vhdl_top)
    RgGen.enable(:register_file, :vhdl_top)
    RgGen.enable(:register, :vhdl_top)
    RgGen.enable(:bit_field, :vhdl_top)
  end

  def create_registers(&body)
    create_vhdl(&body).registers
  end

  context 'レジスタがビットフィールドを持つ場合' do
    def check_bit_field_signals(register, width)
      expect(register).to have_signal(:bit_field_valid)
      expect(register).to have_signal(:bit_field_read_mask, width: width)
      expect(register).to have_signal(:bit_field_write_mask, width: width)
      expect(register).to have_signal(:bit_field_write_data, width: width)
      expect(register).to have_signal(:bit_field_read_data, width: width)
      expect(register).to have_signal(:bit_field_value, width: width)
    end

    it 'ビットフィールドアクセス用の信号群を持つ' do
      registers = create_registers do
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
          size [2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end

        register do
          name 'register_3'
          offset_address 0x30
          size [2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 32; type :rw; initial_value 0 }
        end

        register do
          name 'register_4'
          offset_address 0x40
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end

        register do
          name 'register_5'
          offset_address 0x50
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 32; type :rw; initial_value 0 }
        end
      end

      check_bit_field_signals(registers[0], 32)
      check_bit_field_signals(registers[1], 64)
      check_bit_field_signals(registers[2], 32)
      check_bit_field_signals(registers[3], 64)
      check_bit_field_signals(registers[4], 32)
      check_bit_field_signals(registers[5], 64)
    end
  end

  context 'レジスタがビットフィールドを持たない場合' do
    it 'ビットフィールドアクセス用の信号群を持たない' do
      registers = create_registers do
        name 'block_0'
        byte_size 256
        register do
          name 'register_0'
          offset_address 0x00
          size [64]
          type :external
        end
      end

      expect(registers[0]).to not_have_signal(:bit_field_valid)
      expect(registers[0]).to not_have_signal(:bit_field_read_mask, width: 32)
      expect(registers[0]).to not_have_signal(:bit_field_write_mask, width: 32)
      expect(registers[0]).to not_have_signal(:bit_field_write_data, width: 32)
      expect(registers[0]).to not_have_signal(:bit_field_read_data, width: 32)
      expect(registers[0]).to not_have_signal(:bit_field_value, width: 32)
    end
  end
end
