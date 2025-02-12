# frozen_string_literal: true

RSpec.describe 'register_block/protocol/avalon' do
  include_context 'vhdl common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:address_width, :enable_wide_register, :library_name])
    RgGen.enable(:register_block, [:name, :protocol, :byte_size, :bus_width])
    RgGen.enable(:register_block, :protocol, [:avalon])
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

  def create_register_block(&body)
    configuration = create_configuration(
      address_width: address_width, bus_width: bus_width,
      protocol: :avalon, library_name: library_name
    )
    create_vhdl(configuration, &body).register_blocks.first
  end

  it 'avalon用のポート群を持つ' do
    expect(register_block).to have_port(
      :read,
      name: 'i_read', direction: :in
    )
    expect(register_block).to have_port(
      :write,
      name: 'i_write', direction: :in
    )
    expect(register_block).to have_port(
      :address,
      name: 'i_address', direction: :in, width: 'ADDRESS_WIDTH'
    )
    expect(register_block).to have_port(
      :byteenable,
      name: 'i_byteenable', direction: :in, width: bus_width / 8
    )
    expect(register_block).to have_port(
      :writedata,
      name: 'i_writedata', direction: :in, width: bus_width
    )
    expect(register_block).to have_port(
      :waitrequest,
      name: 'o_waitrequest', direction: :out
    )
    expect(register_block).to have_port(
      :response,
      name: 'o_response', direction: :out, width: 2
    )
    expect(register_block).to have_port(
      :readdata,
      name: 'o_readdata', direction: :out, width: bus_width
    )
  end

  describe '#generate_code' do
    it 'rggen_avalon_adapterをインスタンスするコードを生成する' do
      expect(register_block).to generate_code(:register_block, :top_down, <<~CODE)
        u_adapter: entity #{library_name}.rggen_avalon_adapter
          generic map (
            ADDRESS_WIDTH       => ADDRESS_WIDTH,
            LOCAL_ADDRESS_WIDTH => 8,
            BUS_WIDTH           => 32,
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
            i_read                => i_read,
            i_write               => i_write,
            i_address             => i_address,
            i_byteenable          => i_byteenable,
            i_writedata           => i_writedata,
            o_waitrequest         => o_waitrequest,
            o_response            => o_response,
            o_readdata            => o_readdata,
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
