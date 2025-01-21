# frozen_string_literal: true

RSpec.describe 'register_block/protocol/wishbone' do
  include_context 'vhdl common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:address_width, :enable_wide_register, :library_name])
    RgGen.enable(:register_block, [:name, :protocol, :byte_size, :bus_width])
    RgGen.enable(:register_block, :protocol, [:wishbone])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:register, :type, [:external])
    RgGen.enable(:register_block, [:vhdl_top])
  end

  let(:address_width) { 16 }

  let(:bus_width) { 32 }

  let(:library_name) { ['work', 'foo_lib'].sample }

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
    configuration =
      create_configuration(
        address_width: address_width, bus_width: bus_width,
        protocol: :wishbone, library_name: library_name
      )
    create_vhdl(configuration, &body).register_blocks.first
  end

  it 'ジェネリック#use_stallを持つ' do
    expect(register_block).to have_generic(
      :use_stall,
      name: 'USE_STALL', type: :boolean, default: true
    )
  end

  it 'wishbone用のポート群を持つ' do
    expect(register_block).to have_port(
      :wb_cyc,
      name: 'i_wb_cyc', direction: :in
    )
    expect(register_block).to have_port(
      :wb_stb,
      name: 'i_wb_stb', direction: :in
    )
    expect(register_block).to have_port(
      :wb_stall,
      name: 'o_wb_stall', direction: :out
    )
    expect(register_block).to have_port(
      :wb_adr,
      name: 'i_wb_adr', direction: :in, width: 'ADDRESS_WIDTH'
    )
    expect(register_block).to have_port(
      :wb_we,
      name: 'i_wb_we', direction: :in
    )
    expect(register_block).to have_port(
      :wb_dat_i,
      name: 'i_wb_dat', direction: :in, width: bus_width
    )
    expect(register_block).to have_port(
      :wb_sel,
      name: 'i_wb_sel', direction: :in, width: bus_width / 8
    )
    expect(register_block).to have_port(
      :wb_ack,
      name: 'o_wb_ack', direction: :out
    )
    expect(register_block).to have_port(
      :wb_err,
      name: 'o_wb_err', direction: :out
    )
    expect(register_block).to have_port(
      :wb_rty,
      name: 'o_wb_rty', direction: :out
    )
    expect(register_block).to have_port(
      :wb_dat_o,
      name: 'o_wb_dat', direction: :out, width: bus_width
    )
  end

  describe '#generate_code' do
    it 'rggen_wishbone_adapterをインスタンスするコードを生成する' do
      expect(register_block).to generate_code(:register_block, :top_down, <<~"CODE")
        u_adapter: entity #{library_name}.rggen_wishbone_adapter
          generic map (
            ADDRESS_WIDTH       => ADDRESS_WIDTH,
            LOCAL_ADDRESS_WIDTH => 8,
            BUS_WIDTH           => 32,
            REGISTERS           => 3,
            PRE_DECODE          => PRE_DECODE,
            BASE_ADDRESS        => BASE_ADDRESS,
            BYTE_SIZE           => 256,
            ERROR_STATUS        => ERROR_STATUS,
            INSERT_SLICER       => INSERT_SLICER,
            USE_STALL           => USE_STALL
          )
          port map (
            i_clk                 => i_clk,
            i_rst_n               => i_rst_n,
            i_wb_cyc              => i_wb_cyc,
            i_wb_stb              => i_wb_stb,
            o_wb_stall            => o_wb_stall,
            i_wb_adr              => i_wb_adr,
            i_wb_we               => i_wb_we,
            i_wb_dat              => i_wb_dat,
            i_wb_sel              => i_wb_sel,
            o_wb_ack              => o_wb_ack,
            o_wb_err              => o_wb_err,
            o_wb_rty              => o_wb_rty,
            o_wb_dat              => o_wb_dat,
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
