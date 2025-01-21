# frozen_string_literal: true

RSpec.describe 'register_block/protocol' do
  include_context 'vhdl common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.define_list_item_feature(:register_block, :protocol, :foo) do
      sv_rtl {}
    end
    RgGen.define_list_item_feature(:register_block, :protocol, :foo) do
      vhdl {}
    end

    RgGen.enable(:global, [:address_width])
    RgGen.enable(:register_block, [:protocol, :byte_size, :bus_width])
    RgGen.enable(:register_block, :protocol, :foo)
  end

  let(:bus_width) { 32 }

  let(:address_width) { 32 }

  let(:local_address_width) { 8 }

  let(:vhdl_rtl) do
    configuration = create_configuration(protocol: :foo, bus_width: bus_width, address_width: address_width)
    create_vhdl(configuration) { byte_size 256 }.register_blocks.first
  end

  it 'ジェネリックADDRESS_WIDTH/PRE_DECODE/BASE_ADDRESS/ERROR_STATUS/INSERT_SLICERを持つ' do
    expect(vhdl_rtl).to have_generic(
      :address_width,
      name: 'ADDRESS_WIDTH', type: :positive, default: local_address_width
    )
    expect(vhdl_rtl).to have_generic(
      :pre_decode,
      name: 'PRE_DECODE', type: :boolean, default: false
    )
    expect(vhdl_rtl).to have_generic(
      :base_address,
      name: 'BASE_ADDRESS', default: 'x"0"'
    )
    expect(vhdl_rtl).to have_generic(
      :error_status,
      name: 'ERROR_STATUS', type: :boolean, default: false
    )
    expect(vhdl_rtl).to have_generic(
      :insert_slicer,
      name: 'INSERT_SLICER', type: :boolean, default: false
    )
  end
end
