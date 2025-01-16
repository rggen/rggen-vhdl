# frozen_string_literal: true

RSpec.describe 'register_block/protocol/native' do
  include_context 'vhdl common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :enable_wide_register, :library_name])
    RgGen.enable(:register_block, [:name, :protocol, :byte_size])
    RgGen.enable(:register_block, :protocol, [:native])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:register, :type, [:external])
    RgGen.enable(:register_block, [:vhdl_top])
  end

  let(:address_width) do
    16
  end

  let(:bus_width) do
    32
  end

  let(:library_name) do
    ['work', 'foo_lib'].sample
  end

  let(:register_block) do
    create_register_block do
      name 'block_0'
      byte_size 256
      register { name 'register_0'; offset_address 0x00; size [1]; type :external }
      register { name 'register_1'; offset_address 0x10; size [1]; type :external }
      register { name 'register_2'; offset_address 0x20; size [1]; type :external }
    end
  end

  def create_register_block(&)
    configuration =
      create_configuration(
        address_width:, bus_width:, library_name:, protocol: :native
      )
    create_vhdl(configuration, &).register_blocks.first
  end

  it 'ジェネリックSTROBE_WIDTHを持つ' do
    expect(register_block).to have_generic(
      :strobe_width,
      name: 'STROBE_WIDTH', type: :positive, default: bus_width / 8
    )
  end

  it 'rggen_bus_if用の信号群を持つ' do
    expect(register_block).to have_port(
      :valid,
      name: 'i_csrbus_valid', direction: :in
    )
    expect(register_block).to have_port(
      :access,
      name: 'i_csrbus_access', direction: :in, width: 2
    )
    expect(register_block).to have_port(
      :address,
      name: 'i_csrbus_address', direction: :in, width: 'ADDRESS_WIDTH'
    )
    expect(register_block).to have_port(
      :write_data,
      name: 'i_csrbus_write_data', direction: :in, width: bus_width
    )
    expect(register_block).to have_port(
      :strobe,
      name: 'i_csrbus_strobe', direction: :in, width: 'STROBE_WIDTH'
    )
    expect(register_block).to have_port(
      :ready,
      name: 'o_csrbus_ready', direction: :out
    )
    expect(register_block).to have_port(
      :status,
      name: 'o_csrbus_status', direction: :out, width: 2
    )
    expect(register_block).to have_port(
      :read_data,
      name: 'o_csrbus_read_data', direction: :out, width: bus_width
    )
  end

  describe '#generate_code' do
    it 'rggen_native_adapterをインスタンスするコードを生成する' do
      expect(register_block).to generate_code(:register_block, :top_down, <<~"CODE")
        u_adapter: entity #{library_name}.rggen_native_adapter
          generic map (
            ADDRESS_WIDTH       => ADDRESS_WIDTH,
            LOCAL_ADDRESS_WIDTH => 8,
            BUS_WIDTH           => 32,
            STROBE_WIDTH        => STROBE_WIDTH,
            REGISTERS           => 3,
            PRE_DECODE          => PRE_DECODE,
            BASE_ADDRESS        => BASE_ADDRESS,
            BYTE_SIZE           => 256,
            ERROR_STATUS        => ERROR_STATUS,
            INSERT_SLICER       => INSERT_SLICER
          )
          port map (
            i_clk                 => i_clk,
            i_rst_n               => i_rst_n,
            i_csrbus_valid        => i_csrbus_valid,
            i_csrbus_access       => i_csrbus_access,
            i_csrbus_address      => i_csrbus_address,
            i_csrbus_write_data   => i_csrbus_write_data,
            i_csrbus_strobe       => i_csrbus_strobe,
            o_csrbus_ready        => o_csrbus_ready,
            o_csrbus_status       => o_csrbus_status,
            o_csrbus_read_data    => o_csrbus_read_data,
            o_register_valid      => register_valid,
            o_register_access     => register_access,
            o_register_address    => register_address,
            o_register_write_data => register_write_data,
            o_register_strobe     => register_strobe,
            i_register_active     => register_active,
            i_register_ready      => register_ready,
            i_register_status     => register_status,
            i_register_read_data  => register_read_data
          );
      CODE
    end
  end
end
