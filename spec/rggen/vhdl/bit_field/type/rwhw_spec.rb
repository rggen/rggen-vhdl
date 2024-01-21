# frozen_string_literal: true

RSpec.describe 'bit_field/type/rwhw' do
  include_context 'clean-up builder'
  include_context 'bit field vhdl common'

  before(:all) do
    RgGen.enable(:bit_field, :type, [:rw, :rwhw])
  end

  let(:bit_fields) do
    create_bit_fields do
      byte_size 256

      register do
        name 'register_0'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rwhw; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 1, width: 1; type :rwhw; initial_value 0; reference 'register_4.bit_field_0' }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 4, width: 2; type :rwhw; initial_value 0 }
        bit_field { name 'bit_field_3'; bit_assignment lsb: 6, width: 2; type :rwhw; initial_value 0; reference 'register_4.bit_field_0' }
        bit_field { name 'bit_field_4'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :rwhw; initial_value 0 }
        bit_field { name 'bit_field_5'; bit_assignment lsb: 20, width: 4, sequence_size: 2, step: 8; type :rwhw; initial_value 0; reference 'register_4.bit_field_0' }
      end

      register do
        name 'register_1'
        size [4]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rwhw; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 1, width: 1; type :rwhw; initial_value 0; reference 'register_4.bit_field_0' }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 4, width: 2; type :rwhw; initial_value 0 }
        bit_field { name 'bit_field_3'; bit_assignment lsb: 6, width: 2; type :rwhw; initial_value 0; reference 'register_4.bit_field_0' }
        bit_field { name 'bit_field_4'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :rwhw; initial_value 0 }
        bit_field { name 'bit_field_5'; bit_assignment lsb: 20, width: 4, sequence_size: 2, step: 8; type :rwhw; initial_value 0; reference 'register_4.bit_field_0' }
      end

      register do
        name 'register_2'
        size [2, 2]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rwhw; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 1, width: 1; type :rwhw; initial_value 0; reference 'register_4.bit_field_0' }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 4, width: 2; type :rwhw; initial_value 0 }
        bit_field { name 'bit_field_3'; bit_assignment lsb: 6, width: 2; type :rwhw; initial_value 0; reference 'register_4.bit_field_0' }
        bit_field { name 'bit_field_4'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :rwhw; initial_value 0 }
        bit_field { name 'bit_field_5'; bit_assignment lsb: 20, width: 4, sequence_size: 2, step: 8; type :rwhw; initial_value 0; reference 'register_4.bit_field_0' }
      end

      register_file do
        name 'register_file_3'
        size [2, 2]
        register_file do
          name 'register_file_0'
          register do
            name 'register_0'
            size [2, 2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rwhw; initial_value 0 }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 1, width: 1; type :rwhw; initial_value 0; reference 'register_file_5.register_file_0.register_0.bit_field_0' }
            bit_field { name 'bit_field_2'; bit_assignment lsb: 4, width: 2; type :rwhw; initial_value 0 }
            bit_field { name 'bit_field_3'; bit_assignment lsb: 6, width: 2; type :rwhw; initial_value 0; reference 'register_file_5.register_file_0.register_0.bit_field_0' }
            bit_field { name 'bit_field_4'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :rwhw; initial_value 0 }
            bit_field { name 'bit_field_5'; bit_assignment lsb: 20, width: 4, sequence_size: 2, step: 8; type :rwhw; initial_value 0; reference 'register_file_5.register_file_0.register_0.bit_field_0' }
          end
        end
      end

      register do
        name 'register_4'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
      end

      register_file do
        name 'register_file_5'
        size [2, 2]
        register_file do
          name 'register_file_0'
          register do
            name 'register_0'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          end
        end
      end
    end
  end

  it '入力ポート#value_in/出力ポート#value_outを持つ' do
    expect(bit_fields[0]).to have_port(
      :register_block, :value_in,
      name: 'i_register_0_bit_field_0', direction: :in, width: 1
    )
    expect(bit_fields[0]).to have_port(
      :register_block, :value_out,
      name: 'o_register_0_bit_field_0', direction: :out, width: 1
    )

    expect(bit_fields[2]).to have_port(
      :register_block, :value_in,
      name: 'i_register_0_bit_field_2', direction: :in, width: 2
    )
    expect(bit_fields[2]).to have_port(
      :register_block, :value_out,
      name: 'o_register_0_bit_field_2', direction: :out, width: 2
    )

    expect(bit_fields[4]).to have_port(
      :register_block, :value_in,
      name: 'i_register_0_bit_field_4', direction: :in, width: 4, array_size: [2]
    )
    expect(bit_fields[4]).to have_port(
      :register_block, :value_out,
      name: 'o_register_0_bit_field_4', direction: :out, width: 4, array_size: [2]
    )

    expect(bit_fields[6]).to have_port(
      :register_block, :value_in,
      name: 'i_register_1_bit_field_0', direction: :in, width: 1, array_size: [4]
    )
    expect(bit_fields[6]).to have_port(
      :register_block, :value_out,
      name: 'o_register_1_bit_field_0', direction: :out, width: 1, array_size: [4]
    )

    expect(bit_fields[8]).to have_port(
      :register_block, :value_in,
      name: 'i_register_1_bit_field_2', direction: :in, width: 2, array_size: [4]
    )
    expect(bit_fields[8]).to have_port(
      :register_block, :value_out,
      name: 'o_register_1_bit_field_2', direction: :out, width: 2, array_size: [4]
    )

    expect(bit_fields[10]).to have_port(
      :register_block, :value_in,
      name: 'i_register_1_bit_field_4', direction: :in, width: 4, array_size: [4, 2]
    )
    expect(bit_fields[10]).to have_port(
      :register_block, :value_out,
      name: 'o_register_1_bit_field_4', direction: :out, width: 4, array_size: [4, 2]
    )

    expect(bit_fields[12]).to have_port(
      :register_block, :value_in,
      name: 'i_register_2_bit_field_0', direction: :in, width: 1, array_size: [2, 2]
    )
    expect(bit_fields[12]).to have_port(
      :register_block, :value_out,
      name: 'o_register_2_bit_field_0', direction: :out, width: 1, array_size: [2, 2]
    )

    expect(bit_fields[14]).to have_port(
      :register_block, :value_in,
      name: 'i_register_2_bit_field_2', direction: :in, width: 2, array_size: [2, 2]
    )
    expect(bit_fields[14]).to have_port(
      :register_block, :value_out,
      name: 'o_register_2_bit_field_2', direction: :out, width: 2, array_size: [2, 2]
    )

    expect(bit_fields[16]).to have_port(
      :register_block, :value_in,
      name: 'i_register_2_bit_field_4', direction: :in, width: 4, array_size: [2, 2, 2]
    )
    expect(bit_fields[16]).to have_port(
      :register_block, :value_out,
      name: 'o_register_2_bit_field_4', direction: :out, width: 4, array_size: [2, 2, 2]
    )

    expect(bit_fields[18]).to have_port(
      :register_block, :value_in,
      name: 'i_register_file_3_register_file_0_register_0_bit_field_0', direction: :in, width: 1, array_size: [2, 2, 2, 2]
    )
    expect(bit_fields[18]).to have_port(
      :register_block, :value_out,
      name: 'o_register_file_3_register_file_0_register_0_bit_field_0', direction: :out, width: 1, array_size: [2, 2, 2, 2]
    )

    expect(bit_fields[20]).to have_port(
      :register_block, :value_in,
      name: 'i_register_file_3_register_file_0_register_0_bit_field_2', direction: :in, width: 2, array_size: [2, 2, 2, 2]
    )
    expect(bit_fields[20]).to have_port(
      :register_block, :value_out,
      name: 'o_register_file_3_register_file_0_register_0_bit_field_2', direction: :out, width: 2, array_size: [2, 2, 2, 2]
    )

    expect(bit_fields[22]).to have_port(
      :register_block, :value_in,
      name: 'i_register_file_3_register_file_0_register_0_bit_field_4', direction: :in, width: 4, array_size: [2, 2, 2, 2, 2]
    )
    expect(bit_fields[22]).to have_port(
      :register_block, :value_out,
      name: 'o_register_file_3_register_file_0_register_0_bit_field_4', direction: :out, width: 4, array_size: [2, 2, 2, 2, 2]
    )
  end

  context '参照ビットフィールドを持たない場合' do
    it '入力ポート#validを持つ' do
      expect(bit_fields[0]).to have_port(
        :register_block, :valid,
        name: 'i_register_0_bit_field_0_valid', direction: :in, width: 1
      )
      expect(bit_fields[2]).to have_port(
        :register_block, :valid,
        name: 'i_register_0_bit_field_2_valid', direction: :in, width: 1
      )
      expect(bit_fields[4]).to have_port(
        :register_block, :valid,
        name: 'i_register_0_bit_field_4_valid', direction: :in, width: 1, array_size: [2]
      )

      expect(bit_fields[6]).to have_port(
        :register_block, :valid,
        name: 'i_register_1_bit_field_0_valid', direction: :in, width: 1, array_size: [4]
      )
      expect(bit_fields[8]).to have_port(
        :register_block, :valid,
        name: 'i_register_1_bit_field_2_valid', direction: :in, width: 1, array_size: [4]
      )
      expect(bit_fields[10]).to have_port(
        :register_block, :valid,
        name: 'i_register_1_bit_field_4_valid', direction: :in, width: 1, array_size: [4, 2]
      )

      expect(bit_fields[12]).to have_port(
        :register_block, :valid,
        name: 'i_register_2_bit_field_0_valid', direction: :in, width: 1, array_size: [2, 2]
      )
      expect(bit_fields[14]).to have_port(
        :register_block, :valid,
        name: 'i_register_2_bit_field_2_valid', direction: :in, width: 1, array_size: [2, 2]
      )
      expect(bit_fields[16]).to have_port(
        :register_block, :valid,
        name: 'i_register_2_bit_field_4_valid', direction: :in, width: 1, array_size: [2, 2, 2]
      )

      expect(bit_fields[18]).to have_port(
        :register_block, :valid,
        name: 'i_register_file_3_register_file_0_register_0_bit_field_0_valid', direction: :in, width: 1, array_size: [2, 2, 2, 2]
      )
      expect(bit_fields[20]).to have_port(
        :register_block, :valid,
        name: 'i_register_file_3_register_file_0_register_0_bit_field_2_valid', direction: :in, width: 1, array_size: [2, 2, 2, 2]
      )
      expect(bit_fields[22]).to have_port(
        :register_block, :valid,
        name: 'i_register_file_3_register_file_0_register_0_bit_field_4_valid', direction: :in, width: 1, array_size: [2, 2, 2, 2, 2]
      )
    end
  end

  context '参照ビットフィールドを持つ場合' do
    it '入力ポート#validを持たない' do
      expect(bit_fields[1]).to not_have_port(
        :register_block, :valid,
        name: 'i_register_0_bit_field_1_valid', direction: :in, width: 1
      )
      expect(bit_fields[3]).to not_have_port(
        :register_block, :valid,
        name: 'i_register_0_bit_field_3_valid', direction: :in, width: 1
      )
      expect(bit_fields[5]).to not_have_port(
        :register_block, :valid,
        name: 'i_register_0_bit_field_5_valid', direction: :in, width: 1, array_size: [2]
      )

      expect(bit_fields[7]).to not_have_port(
        :register_block, :valid,
        name: 'i_register_1_bit_field_1_valid', direction: :in, width: 1, array_size: [4]
      )
      expect(bit_fields[9]).to not_have_port(
        :register_block, :valid,
        name: 'i_register_1_bit_field_3_valid', direction: :in, width: 1, array_size: [4]
      )
      expect(bit_fields[11]).to not_have_port(
        :register_block, :valid,
        name: 'i_register_1_bit_field_5_valid', direction: :in, width: 1, array_size: [4, 2]
      )

      expect(bit_fields[13]).to not_have_port(
        :register_block, :valid,
        name: 'i_register_2_bit_field_1_valid', direction: :in, width: 1, array_size: [2, 2]
      )
      expect(bit_fields[15]).to not_have_port(
        :register_block, :valid,
        name: 'i_register_2_bit_field_3_valid', direction: :in, width: 1, array_size: [2, 2]
      )
      expect(bit_fields[17]).to not_have_port(
        :register_block, :valid,
        name: 'i_register_2_bit_field_5_valid', direction: :in, width: 1, array_size: [2, 2, 2]
      )

      expect(bit_fields[19]).to not_have_port(
        :register_block, :valid,
        name: 'i_register_file_3_register_file_0_register_0_bit_field_1_valid', direction: :in, width: 1, array_size: [2, 2, 2, 2]
      )
      expect(bit_fields[21]).to not_have_port(
        :register_block, :valid,
        name: 'i_register_file_3_register_file_0_register_0_bit_field_3_valid', direction: :in, width: 1, array_size: [2, 2, 2, 2]
      )
      expect(bit_fields[23]).to not_have_port(
        :register_block, :valid,
        name: 'i_register_file_3_register_file_0_register_0_bit_field_5_valid', direction: :in, width: 1, array_size: [2, 2, 2, 2, 2]
      )
    end
  end

  describe '#generate_code' do
    it 'rggen_bit_fieldをインスタンスするコードを出力する' do
      expect(bit_fields[0]).to generate_code(:bit_field, :top_down, <<~'CODE')
        u_bit_field: entity work.rggen_bit_field
          generic map (
            WIDTH         => 1,
            INITIAL_VALUE => slice(x"0", 1, 0)
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
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => i_register_0_bit_field_0_valid,
            i_hw_write_data   => i_register_0_bit_field_0,
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_0_bit_field_0,
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[1]).to generate_code(:bit_field, :top_down, <<~'CODE')
        u_bit_field: entity work.rggen_bit_field
          generic map (
            WIDTH         => 1,
            INITIAL_VALUE => slice(x"0", 1, 0)
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(1 downto 1),
            i_sw_write_enable => "1",
            i_sw_write_mask   => bit_field_write_mask(1 downto 1),
            i_sw_write_data   => bit_field_write_data(1 downto 1),
            o_sw_read_data    => bit_field_read_data(1 downto 1),
            o_sw_value        => bit_field_value(1 downto 1),
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => register_value(800 downto 800),
            i_hw_write_data   => i_register_0_bit_field_1,
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_0_bit_field_1,
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[2]).to generate_code(:bit_field, :top_down, <<~'CODE')
        u_bit_field: entity work.rggen_bit_field
          generic map (
            WIDTH         => 2,
            INITIAL_VALUE => slice(x"0", 2, 0)
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(5 downto 4),
            i_sw_write_enable => "1",
            i_sw_write_mask   => bit_field_write_mask(5 downto 4),
            i_sw_write_data   => bit_field_write_data(5 downto 4),
            o_sw_read_data    => bit_field_read_data(5 downto 4),
            o_sw_value        => bit_field_value(5 downto 4),
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => i_register_0_bit_field_2_valid,
            i_hw_write_data   => i_register_0_bit_field_2,
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_0_bit_field_2,
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[3]).to generate_code(:bit_field, :top_down, <<~'CODE')
        u_bit_field: entity work.rggen_bit_field
          generic map (
            WIDTH         => 2,
            INITIAL_VALUE => slice(x"0", 2, 0)
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(7 downto 6),
            i_sw_write_enable => "1",
            i_sw_write_mask   => bit_field_write_mask(7 downto 6),
            i_sw_write_data   => bit_field_write_data(7 downto 6),
            o_sw_read_data    => bit_field_read_data(7 downto 6),
            o_sw_value        => bit_field_value(7 downto 6),
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => register_value(800 downto 800),
            i_hw_write_data   => i_register_0_bit_field_3,
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_0_bit_field_3,
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[4]).to generate_code(:bit_field, :top_down, <<~'CODE')
        u_bit_field: entity work.rggen_bit_field
          generic map (
            WIDTH         => 4,
            INITIAL_VALUE => slice(x"0", 4, 0)
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
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => i_register_0_bit_field_4_valid(1*(i)+0 downto 1*(i)),
            i_hw_write_data   => i_register_0_bit_field_4(4*(i)+3 downto 4*(i)),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_0_bit_field_4(4*(i)+3 downto 4*(i)),
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[5]).to generate_code(:bit_field, :top_down, <<~'CODE')
        u_bit_field: entity work.rggen_bit_field
          generic map (
            WIDTH         => 4,
            INITIAL_VALUE => slice(x"0", 4, 0)
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(20+8*i+3 downto 20+8*i),
            i_sw_write_enable => "1",
            i_sw_write_mask   => bit_field_write_mask(20+8*i+3 downto 20+8*i),
            i_sw_write_data   => bit_field_write_data(20+8*i+3 downto 20+8*i),
            o_sw_read_data    => bit_field_read_data(20+8*i+3 downto 20+8*i),
            o_sw_value        => bit_field_value(20+8*i+3 downto 20+8*i),
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => register_value(800 downto 800),
            i_hw_write_data   => i_register_0_bit_field_5(4*(i)+3 downto 4*(i)),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_0_bit_field_5(4*(i)+3 downto 4*(i)),
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[10]).to generate_code(:bit_field, :top_down, <<~'CODE')
        u_bit_field: entity work.rggen_bit_field
          generic map (
            WIDTH         => 4,
            INITIAL_VALUE => slice(x"0", 4, 0)
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
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => i_register_1_bit_field_4_valid(1*(2*i+j)+0 downto 1*(2*i+j)),
            i_hw_write_data   => i_register_1_bit_field_4(4*(2*i+j)+3 downto 4*(2*i+j)),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_1_bit_field_4(4*(2*i+j)+3 downto 4*(2*i+j)),
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[11]).to generate_code(:bit_field, :top_down, <<~'CODE')
        u_bit_field: entity work.rggen_bit_field
          generic map (
            WIDTH         => 4,
            INITIAL_VALUE => slice(x"0", 4, 0)
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(20+8*j+3 downto 20+8*j),
            i_sw_write_enable => "1",
            i_sw_write_mask   => bit_field_write_mask(20+8*j+3 downto 20+8*j),
            i_sw_write_data   => bit_field_write_data(20+8*j+3 downto 20+8*j),
            o_sw_read_data    => bit_field_read_data(20+8*j+3 downto 20+8*j),
            o_sw_value        => bit_field_value(20+8*j+3 downto 20+8*j),
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => register_value(800 downto 800),
            i_hw_write_data   => i_register_1_bit_field_5(4*(2*i+j)+3 downto 4*(2*i+j)),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_1_bit_field_5(4*(2*i+j)+3 downto 4*(2*i+j)),
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[16]).to generate_code(:bit_field, :top_down, <<~'CODE')
        u_bit_field: entity work.rggen_bit_field
          generic map (
            WIDTH         => 4,
            INITIAL_VALUE => slice(x"0", 4, 0)
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
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => i_register_2_bit_field_4_valid(1*(4*i+2*j+k)+0 downto 1*(4*i+2*j+k)),
            i_hw_write_data   => i_register_2_bit_field_4(4*(4*i+2*j+k)+3 downto 4*(4*i+2*j+k)),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_2_bit_field_4(4*(4*i+2*j+k)+3 downto 4*(4*i+2*j+k)),
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[17]).to generate_code(:bit_field, :top_down, <<~'CODE')
        u_bit_field: entity work.rggen_bit_field
          generic map (
            WIDTH         => 4,
            INITIAL_VALUE => slice(x"0", 4, 0)
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(20+8*k+3 downto 20+8*k),
            i_sw_write_enable => "1",
            i_sw_write_mask   => bit_field_write_mask(20+8*k+3 downto 20+8*k),
            i_sw_write_data   => bit_field_write_data(20+8*k+3 downto 20+8*k),
            o_sw_read_data    => bit_field_read_data(20+8*k+3 downto 20+8*k),
            o_sw_value        => bit_field_value(20+8*k+3 downto 20+8*k),
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => register_value(800 downto 800),
            i_hw_write_data   => i_register_2_bit_field_5(4*(4*i+2*j+k)+3 downto 4*(4*i+2*j+k)),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_2_bit_field_5(4*(4*i+2*j+k)+3 downto 4*(4*i+2*j+k)),
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[22]).to generate_code(:bit_field, :top_down, <<~'CODE')
        u_bit_field: entity work.rggen_bit_field
          generic map (
            WIDTH         => 4,
            INITIAL_VALUE => slice(x"0", 4, 0)
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
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => i_register_file_3_register_file_0_register_0_bit_field_4_valid(1*(16*i+8*j+4*k+2*l+m)+0 downto 1*(16*i+8*j+4*k+2*l+m)),
            i_hw_write_data   => i_register_file_3_register_file_0_register_0_bit_field_4(4*(16*i+8*j+4*k+2*l+m)+3 downto 4*(16*i+8*j+4*k+2*l+m)),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_file_3_register_file_0_register_0_bit_field_4(4*(16*i+8*j+4*k+2*l+m)+3 downto 4*(16*i+8*j+4*k+2*l+m)),
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[23]).to generate_code(:bit_field, :top_down, <<~'CODE')
        u_bit_field: entity work.rggen_bit_field
          generic map (
            WIDTH         => 4,
            INITIAL_VALUE => slice(x"0", 4, 0)
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(20+8*m+3 downto 20+8*m),
            i_sw_write_enable => "1",
            i_sw_write_mask   => bit_field_write_mask(20+8*m+3 downto 20+8*m),
            i_sw_write_data   => bit_field_write_data(20+8*m+3 downto 20+8*m),
            o_sw_read_data    => bit_field_read_data(20+8*m+3 downto 20+8*m),
            o_sw_value        => bit_field_value(20+8*m+3 downto 20+8*m),
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => register_value(32*(26+2*i+j)+0+0 downto 32*(26+2*i+j)+0),
            i_hw_write_data   => i_register_file_3_register_file_0_register_0_bit_field_5(4*(16*i+8*j+4*k+2*l+m)+3 downto 4*(16*i+8*j+4*k+2*l+m)),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_file_3_register_file_0_register_0_bit_field_5(4*(16*i+8*j+4*k+2*l+m)+3 downto 4*(16*i+8*j+4*k+2*l+m)),
            o_value_unmasked  => open
          );
      CODE
    end
  end
end
