# frozen_string_literal: true

RSpec.describe 'register_block/protocol/axi4lite' do
  include_context 'vhdl common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :enable_wide_register, :library_name])
    RgGen.enable(:register_block, [:name, :protocol, :byte_size])
    RgGen.enable(:register_block, :protocol, [:axi4lite])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:register, :type, [:external])
    RgGen.enable(:register_block, [:vhdl_top])
  end

  let(:address_width) { 16 }

  let(:bus_width) { 32 }

  let(:library_name) { ['work', 'foo_lib'].sample }

  def create_register_block(&body)
    configuration =
      create_configuration(
        address_width: address_width, bus_width: bus_width,
        protocol: :axi4lite, library_name: library_name
      )
    create_vhdl(configuration, &body).register_blocks.first
  end

  it 'ジェネリックID_WIDTH/WRITE_FIRSTを持つ' do
    register_block = create_register_block do
      name 'block_0'
      byte_size 256
      register { name 'register_0'; offset_address 0x00; size [1]; type :external }
    end

    expect(register_block).to have_generic(
      :id_width,
      name: 'ID_WIDTH', type: :natural, default: 0
    )
    expect(register_block).to have_generic(
      :write_first,
      name: 'WRITE_FIRST', type: :boolean, default: true
    )
  end

  it 'AXI4LITE用のポート群を持つ' do
    register_block = create_register_block do
      name 'block_0'
      byte_size 256
      register { name 'register_0'; offset_address 0x00; size [1]; type :external }
    end

    expect(register_block).to have_port(
      :awvalid,
      name: 'i_awvalid', direction: :in
    )
    expect(register_block).to have_port(
      :awready,
      name: 'o_awready', direction: :out
    )
    expect(register_block).to have_port(
      :awid,
      name: 'i_awid', direction: :in, width: 'clip_id_width(ID_WIDTH)'
    )
    expect(register_block).to have_port(
      :awaddr,
      name: 'i_awaddr', direction: :in, width: 'ADDRESS_WIDTH'
    )
    expect(register_block).to have_port(
      :awprot,
      name: 'i_awprot', direction: :in, width: 3
    )
    expect(register_block).to have_port(
      :wvalid,
      name: 'i_wvalid', direction: :in
    )
    expect(register_block).to have_port(
      :wready,
      name: 'o_wready', direction: :out
    )
    expect(register_block).to have_port(
      :wdata,
      name: 'i_wdata', direction: :in, width: bus_width
    )
    expect(register_block).to have_port(
      :wstrb,
      name: 'i_wstrb', direction: :in, width: bus_width / 8
    )
    expect(register_block).to have_port(
      :bvalid,
      name: 'o_bvalid', direction: :out
    )
    expect(register_block).to have_port(
      :bready,
      name: 'i_bready', direction: :in
    )
    expect(register_block).to have_port(
      :bid,
      name: 'o_bid', direction: :out, width: 'clip_id_width(ID_WIDTH)'
    )
    expect(register_block).to have_port(
      :bresp,
      name: 'o_bresp', direction: :out, width: 2
    )
    expect(register_block).to have_port(
      :arvalid,
      name: 'i_arvalid', direction: :in
    )
    expect(register_block).to have_port(
      :arready,
      name: 'o_arready', direction: :out
    )
    expect(register_block).to have_port(
      :arid,
      name: 'i_arid', direction: :in, width: 'clip_id_width(ID_WIDTH)'
    )
    expect(register_block).to have_port(
      :araddr,
      name: 'i_araddr', direction: :in, width: 'ADDRESS_WIDTH'
    )
    expect(register_block).to have_port(
      :arprot,
      name: 'i_arprot', direction: :in, width: 3
    )
    expect(register_block).to have_port(
      :rvalid,
      name: 'o_rvalid', direction: :out
    )
    expect(register_block).to have_port(
      :rready,
      name: 'i_rready', direction: :in
    )
    expect(register_block).to have_port(
      :rid,
      name: 'o_rid', direction: :out, width: 'clip_id_width(ID_WIDTH)'
    )
    expect(register_block).to have_port(
      :rdata,
      name: 'o_rdata', direction: :out, width: bus_width
    )
    expect(register_block).to have_port(
      :rresp,
      name: 'o_rresp', direction: :out, width: 2
    )
  end

  describe '#generate_code' do
    it 'rggen_axi4lite_adapterをインスタンスするコードを生成する' do
      register_block = create_register_block do
        name 'block_0'
          byte_size 256
          register { name 'register_0'; offset_address 0x00; size [1]; type :external }
          register { name 'register_1'; offset_address 0x10; size [1]; type :external }
          register { name 'register_2'; offset_address 0x20; size [1]; type :external }
      end

      expect(register_block).to generate_code(:register_block, :top_down, <<~"CODE")
        u_adapter: entity #{library_name}.rggen_axi4lite_adapter
          generic map (
            ID_WIDTH            => ID_WIDTH,
            ADDRESS_WIDTH       => ADDRESS_WIDTH,
            LOCAL_ADDRESS_WIDTH => 8,
            BUS_WIDTH           => 32,
            REGISTERS           => 3,
            PRE_DECODE          => PRE_DECODE,
            BASE_ADDRESS        => BASE_ADDRESS,
            BYTE_SIZE           => 256,
            ERROR_STATUS        => ERROR_STATUS,
            INSERT_SLICER       => INSERT_SLICER,
            WRITE_FIRST         => WRITE_FIRST
          )
          port map (
            i_clk                 => i_clk,
            i_rst_n               => i_rst_n,
            i_awvalid             => i_awvalid,
            o_awready             => o_awready,
            i_awid                => i_awid,
            i_awaddr              => i_awaddr,
            i_awprot              => i_awprot,
            i_wvalid              => i_wvalid,
            o_wready              => o_wready,
            i_wdata               => i_wdata,
            i_wstrb               => i_wstrb,
            o_bvalid              => o_bvalid,
            i_bready              => i_bready,
            o_bid                 => o_bid,
            o_bresp               => o_bresp,
            i_arvalid             => i_arvalid,
            o_arready             => o_arready,
            i_arid                => i_arid,
            i_araddr              => i_araddr,
            i_arprot              => i_arprot,
            o_rvalid              => o_rvalid,
            i_rready              => i_rready,
            o_rid                 => o_rid,
            o_rdata               => o_rdata,
            o_rresp               => o_rresp,
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
