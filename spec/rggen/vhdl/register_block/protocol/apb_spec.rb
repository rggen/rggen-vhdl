# frozen_string_literal: true

RSpec.describe 'register_block/protocol/apb' do
  include_context 'vhdl common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:address_width, :enable_wide_register, :library_name])
    RgGen.enable(:register_block, [:name, :protocol, :byte_size, :bus_width])
    RgGen.enable(:register_block, :protocol, [:apb])
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
        protocol: :apb, library_name: library_name
      )
    create_vhdl(configuration, &body).register_blocks.first
  end

  it 'APB用のポート群を持つ' do
    register_block = create_register_block do
      name 'block_0'
      byte_size 256
      register { name 'register_0'; offset_address 0x00; size [1]; type :external }
    end

    expect(register_block).to have_port(
      :psel,
      name: 'i_psel', direction: :in
    )
    expect(register_block).to have_port(
      :penable,
      name: 'i_penable', direction: :in
    )
    expect(register_block).to have_port(
      :paddr,
      name: 'i_paddr', direction: :in, width: 'ADDRESS_WIDTH'
    )
    expect(register_block).to have_port(
      :pprot,
      name: 'i_pprot', direction: :in, width: 3
    )
    expect(register_block).to have_port(
      :pwrite,
      name: 'i_pwrite', direction: :in
    )
    expect(register_block).to have_port(
      :pstrb,
      name: 'i_pstrb', direction: :in, width: bus_width / 8
    )
    expect(register_block).to have_port(
      :pwdata,
      name: 'i_pwdata', direction: :in, width: bus_width
    )
    expect(register_block).to have_port(
      :pready,
      name: 'o_pready', direction: :out
    )
    expect(register_block).to have_port(
      :prdata,
      name: 'o_prdata', direction: :out, width: bus_width
    )
    expect(register_block).to have_port(
      :pslverr,
      name: 'o_pslverr', direction: :out
    )
  end

  describe '#generate_code' do
    it 'rggen_apb_adapterをインスタンスするコードを生成する' do
      register_block = create_register_block do
        name 'block_0'
          byte_size 256
          register { name 'register_0'; offset_address 0x00; size [1]; type :external }
          register { name 'register_1'; offset_address 0x10; size [1]; type :external }
          register { name 'register_2'; offset_address 0x20; size [1]; type :external }
      end

      expect(register_block).to generate_code(:register_block, :top_down, <<~"CODE")
        u_adapter: entity #{library_name}.rggen_apb_adaper
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
            i_psel                => i_psel,
            i_penable             => i_penable,
            i_paddr               => i_paddr,
            i_pprot               => i_pprot,
            i_pwrite              => i_pwrite,
            i_pstrb               => i_pstrb,
            i_pwdata              => i_pwdata,
            o_pready              => o_pready,
            o_prdata              => o_prdata,
            o_pslverr             => o_pslverr,
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
