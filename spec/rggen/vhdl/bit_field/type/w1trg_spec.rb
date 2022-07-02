# frozen_string_literal: true

RSpec.describe 'bit_field/type/w1trg' do
  include_context 'clean-up builder'
  include_context 'bit field vhdl common'

  before(:all) do
    RgGen.enable(:bit_field, :type, [:w1trg])
  end

  let(:bit_fields) do
    create_bit_fields do
      byte_size 256

      register do
        name 'register_0'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :w1trg }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 4; type :w1trg }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :w1trg }
      end

      register do
        name 'register_1'
        size [4]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :w1trg }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 4; type :w1trg }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :w1trg }
      end

      register do
        name 'register_2'
        size [2, 2]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :w1trg }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 4; type :w1trg }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :w1trg }
      end

      register_file do
        name 'register_file_3'
        size [2, 2]
        register_file do
          name 'register_file_0'
          register do
            name 'register_0'
            size [2, 2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :w1trg }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 4; type :w1trg }
            bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :w1trg }
          end
        end
      end
    end
  end

  it '出力ポート#triggerを持つ' do
    expect(bit_fields[0]).to have_port(
      :register_block, :trigger,
      name: 'o_register_0_bit_field_0_trigger', direction: :out, width: 1
    )
    expect(bit_fields[1]).to have_port(
      :register_block, :trigger,
      name: 'o_register_0_bit_field_1_trigger', direction: :out, width: 4
    )
    expect(bit_fields[2]).to have_port(
      :register_block, :trigger,
      name: 'o_register_0_bit_field_2_trigger', direction: :out, width: 4, array_size: [2]
    )

    expect(bit_fields[3]).to have_port(
      :register_block, :trigger,
      name: 'o_register_1_bit_field_0_trigger', direction: :out, width: 1, array_size: [4]
    )
    expect(bit_fields[4]).to have_port(
      :register_block, :trigger,
      name: 'o_register_1_bit_field_1_trigger', direction: :out, width: 4, array_size: [4]
    )
    expect(bit_fields[5]).to have_port(
      :register_block, :trigger,
      name: 'o_register_1_bit_field_2_trigger', direction: :out, width: 4, array_size: [4, 2]
    )

    expect(bit_fields[6]).to have_port(
      :register_block, :trigger,
      name: 'o_register_2_bit_field_0_trigger', direction: :out, width: 1, array_size: [2, 2]
    )
    expect(bit_fields[7]).to have_port(
      :register_block, :trigger,
      name: 'o_register_2_bit_field_1_trigger', direction: :out, width: 4, array_size: [2, 2]
    )
    expect(bit_fields[8]).to have_port(
      :register_block, :trigger,
      name: 'o_register_2_bit_field_2_trigger', direction: :out, width: 4, array_size: [2, 2, 2]
    )

    expect(bit_fields[9]).to have_port(
      :register_block, :trigger,
      name: 'o_register_file_3_register_file_0_register_0_bit_field_0_trigger', direction: :out, width: 1, array_size: [2, 2, 2, 2]
    )
    expect(bit_fields[10]).to have_port(
      :register_block, :trigger,
      name: 'o_register_file_3_register_file_0_register_0_bit_field_1_trigger', direction: :out, width: 4, array_size: [2, 2, 2, 2]
    )
    expect(bit_fields[11]).to have_port(
      :register_block, :trigger,
      name: 'o_register_file_3_register_file_0_register_0_bit_field_2_trigger', direction: :out, width: 4, array_size: [2, 2, 2, 2, 2]
    )
  end

  describe '#generate_code' do
    it 'rggen_bit_field_w01trgをインスタンスするコードを生成する' do
      expect(bit_fields[0]).to generate_code(:bit_field, :top_down, <<~'CODE')
        u_bit_field: entity work.rggen_bit_field_w01trg
          generic map (
            WRITE_ONE_TRIGGER => true,
            WIDTH             => 1
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(0 downto 0),
            i_sw_write_enable => "1",
            i_sw_write_mask   => bit_field_write_mask(0 downto 0),
            i_sw_write_data   => bit_field_write_data(0 downto 0),
            o_sw_read_data    => bit_field_read_data(0 downto 0),
            o_sw_value        => bit_field_value(0 downto 0),
            i_value           => (others => '0'),
            o_trigger         => o_register_0_bit_field_0_trigger
          );
      CODE

      expect(bit_fields[1]).to generate_code(:bit_field, :top_down, <<~'CODE')
        u_bit_field: entity work.rggen_bit_field_w01trg
          generic map (
            WRITE_ONE_TRIGGER => true,
            WIDTH             => 4
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(11 downto 8),
            i_sw_write_enable => "1",
            i_sw_write_mask   => bit_field_write_mask(11 downto 8),
            i_sw_write_data   => bit_field_write_data(11 downto 8),
            o_sw_read_data    => bit_field_read_data(11 downto 8),
            o_sw_value        => bit_field_value(11 downto 8),
            i_value           => (others => '0'),
            o_trigger         => o_register_0_bit_field_1_trigger
          );
      CODE

      expect(bit_fields[2]).to generate_code(:bit_field, :top_down, <<~'CODE')
        u_bit_field: entity work.rggen_bit_field_w01trg
          generic map (
            WRITE_ONE_TRIGGER => true,
            WIDTH             => 4
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(16+8*i+3 downto 16+8*i),
            i_sw_write_enable => "1",
            i_sw_write_mask   => bit_field_write_mask(16+8*i+3 downto 16+8*i),
            i_sw_write_data   => bit_field_write_data(16+8*i+3 downto 16+8*i),
            o_sw_read_data    => bit_field_read_data(16+8*i+3 downto 16+8*i),
            o_sw_value        => bit_field_value(16+8*i+3 downto 16+8*i),
            i_value           => (others => '0'),
            o_trigger         => o_register_0_bit_field_2_trigger(4*(i)+3 downto 4*(i))
          );
      CODE

      expect(bit_fields[5]).to generate_code(:bit_field, :top_down, <<~'CODE')
        u_bit_field: entity work.rggen_bit_field_w01trg
          generic map (
            WRITE_ONE_TRIGGER => true,
            WIDTH             => 4
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(16+8*j+3 downto 16+8*j),
            i_sw_write_enable => "1",
            i_sw_write_mask   => bit_field_write_mask(16+8*j+3 downto 16+8*j),
            i_sw_write_data   => bit_field_write_data(16+8*j+3 downto 16+8*j),
            o_sw_read_data    => bit_field_read_data(16+8*j+3 downto 16+8*j),
            o_sw_value        => bit_field_value(16+8*j+3 downto 16+8*j),
            i_value           => (others => '0'),
            o_trigger         => o_register_1_bit_field_2_trigger(4*(2*i+j)+3 downto 4*(2*i+j))
          );
      CODE

      expect(bit_fields[8]).to generate_code(:bit_field, :top_down, <<~'CODE')
        u_bit_field: entity work.rggen_bit_field_w01trg
          generic map (
            WRITE_ONE_TRIGGER => true,
            WIDTH             => 4
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(16+8*k+3 downto 16+8*k),
            i_sw_write_enable => "1",
            i_sw_write_mask   => bit_field_write_mask(16+8*k+3 downto 16+8*k),
            i_sw_write_data   => bit_field_write_data(16+8*k+3 downto 16+8*k),
            o_sw_read_data    => bit_field_read_data(16+8*k+3 downto 16+8*k),
            o_sw_value        => bit_field_value(16+8*k+3 downto 16+8*k),
            i_value           => (others => '0'),
            o_trigger         => o_register_2_bit_field_2_trigger(4*(4*i+2*j+k)+3 downto 4*(4*i+2*j+k))
          );
      CODE

      expect(bit_fields[11]).to generate_code(:bit_field, :top_down, <<~'CODE')
        u_bit_field: entity work.rggen_bit_field_w01trg
          generic map (
            WRITE_ONE_TRIGGER => true,
            WIDTH             => 4
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(16+8*m+3 downto 16+8*m),
            i_sw_write_enable => "1",
            i_sw_write_mask   => bit_field_write_mask(16+8*m+3 downto 16+8*m),
            i_sw_write_data   => bit_field_write_data(16+8*m+3 downto 16+8*m),
            o_sw_read_data    => bit_field_read_data(16+8*m+3 downto 16+8*m),
            o_sw_value        => bit_field_value(16+8*m+3 downto 16+8*m),
            i_value           => (others => '0'),
            o_trigger         => o_register_file_3_register_file_0_register_0_bit_field_2_trigger(4*(16*i+8*j+4*k+2*l+m)+3 downto 4*(16*i+8*j+4*k+2*l+m))
          );
      CODE
    end
  end
end
