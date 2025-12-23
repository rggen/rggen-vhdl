# frozen_string_literal: true

RSpec.describe 'bit_field/type/counter' do
  include_context 'clean-up builder'
  include_context 'bit field vhdl common'

  before(:all) do
    RgGen.enable(:bit_field, :type, [:rw, :counter])
  end

  let(:bit_fields) do
    create_bit_fields do
      byte_size 256

      register do
        name 'register_0'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :counter; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :counter; initial_value 0xab }
      end

      register do
        name 'register_1'
        size [2]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :counter; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :counter; initial_value 0xcd }
      end

      register do
        name 'register_2'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :counter; initial_value 0; reference 'register_3.bit_field_0' }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :counter; initial_value 0xef; reference 'register_3.bit_field_0' }
      end

      register do
        name 'register_3'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end
    end
  end

  it 'ジェネリック #up_width/#down_width/#wrap_around を持つ' do
    expect(bit_fields[0]).to have_generic(
      :register_block, :up_width,
      name: 'REGISTER_0_BIT_FIELD_0_UP_WIDTH', type: :natural, default: 1
    )
    expect(bit_fields[0]).to have_generic(
      :register_block, :down_width,
      name: 'REGISTER_0_BIT_FIELD_0_DOWN_WIDTH', type: :natural, default: 1
    )
    expect(bit_fields[0]).to have_generic(
      :register_block, :wrap_around,
      name: 'REGISTER_0_BIT_FIELD_0_WRAP_AROUND', type: :boolean, default: false
    )

    expect(bit_fields[2]).to have_generic(
      :register_block, :up_width,
      name: 'REGISTER_1_BIT_FIELD_0_UP_WIDTH', type: :natural, default: 1
    )
    expect(bit_fields[2]).to have_generic(
      :register_block, :down_width,
      name: 'REGISTER_1_BIT_FIELD_0_DOWN_WIDTH', type: :natural, default: 1
    )
    expect(bit_fields[2]).to have_generic(
      :register_block, :wrap_around,
      name: 'REGISTER_1_BIT_FIELD_0_WRAP_AROUND', type: :boolean, default: false
    )

    expect(bit_fields[4]).to have_generic(
      :register_block, :up_width,
      name: 'REGISTER_2_BIT_FIELD_0_UP_WIDTH', type: :natural, default: 1
    )
    expect(bit_fields[4]).to have_generic(
      :register_block, :down_width,
      name: 'REGISTER_2_BIT_FIELD_0_DOWN_WIDTH', type: :natural, default: 1
    )
    expect(bit_fields[4]).to have_generic(
      :register_block, :wrap_around,
      name: 'REGISTER_2_BIT_FIELD_0_WRAP_AROUND', type: :boolean, default: false
    )
  end

  it '入力ポート#up/入力ポート#down/出力ポート#countを持つ' do
    expect(bit_fields[0]).to have_port(
      :register_block, :up,
      name: 'i_register_0_bit_field_0_up', direction: :in, width: 'clip_width(REGISTER_0_BIT_FIELD_0_UP_WIDTH)'
    )
    expect(bit_fields[0]).to have_port(
      :register_block, :down,
      name: 'i_register_0_bit_field_0_down', direction: :in, width: 'clip_width(REGISTER_0_BIT_FIELD_0_DOWN_WIDTH)'
    )
    expect(bit_fields[0]).to have_port(
      :register_block, :count,
      name: 'o_register_0_bit_field_0', direction: :out, width: 1
    )

    expect(bit_fields[1]).to have_port(
      :register_block, :up,
      name: 'i_register_0_bit_field_1_up', direction: :in, width: 'clip_width(REGISTER_0_BIT_FIELD_1_UP_WIDTH)'
    )
    expect(bit_fields[1]).to have_port(
      :register_block, :down,
      name: 'i_register_0_bit_field_1_down', direction: :in, width: 'clip_width(REGISTER_0_BIT_FIELD_1_DOWN_WIDTH)'
    )
    expect(bit_fields[1]).to have_port(
      :register_block, :count,
      name: 'o_register_0_bit_field_1', direction: :out, width: 8
    )

    expect(bit_fields[2]).to have_port(
      :register_block, :up,
      name: 'i_register_1_bit_field_0_up', direction: :in, width: 'clip_width(REGISTER_1_BIT_FIELD_0_UP_WIDTH)',
      array_size: [2]
    )
    expect(bit_fields[2]).to have_port(
      :register_block, :down,
      name: 'i_register_1_bit_field_0_down', direction: :in, width: 'clip_width(REGISTER_1_BIT_FIELD_0_DOWN_WIDTH)',
      array_size: [2]
    )
    expect(bit_fields[2]).to have_port(
      :register_block, :count,
      name: 'o_register_1_bit_field_0', direction: :out, width: 1,
      array_size: [2]
    )

    expect(bit_fields[3]).to have_port(
      :register_block, :up,
      name: 'i_register_1_bit_field_1_up', direction: :in, width: 'clip_width(REGISTER_1_BIT_FIELD_1_UP_WIDTH)',
      array_size: [2]
    )
    expect(bit_fields[3]).to have_port(
      :register_block, :down,
      name: 'i_register_1_bit_field_1_down', direction: :in, width: 'clip_width(REGISTER_1_BIT_FIELD_1_DOWN_WIDTH)',
      array_size: [2]
    )
    expect(bit_fields[3]).to have_port(
      :register_block, :count,
      name: 'o_register_1_bit_field_1', direction: :out, width: 8,
      array_size: [2]
    )
  end

  context '参照ビットフィールドを持たない場合' do
    it 'ジェネリクス #use_clearを持つ' do
      expect(bit_fields[0]).to have_generic(
        :register_block, :use_clear,
        name: 'REGISTER_0_BIT_FIELD_0_USE_CLEAR', type: :boolean, default: true
      )

      expect(bit_fields[1]).to have_generic(
        :register_block, :use_clear,
        name: 'REGISTER_0_BIT_FIELD_1_USE_CLEAR', type: :boolean, default: true
      )

      expect(bit_fields[2]).to have_generic(
        :register_block, :use_clear,
        name: 'REGISTER_1_BIT_FIELD_0_USE_CLEAR', type: :boolean, default: true
      )

      expect(bit_fields[3]).to have_generic(
        :register_block, :use_clear,
        name: 'REGISTER_1_BIT_FIELD_1_USE_CLEAR', type: :boolean, default: true
      )
    end

    it '入力ポート#clearを持つ' do
      expect(bit_fields[0]).to have_port(
        :register_block, :clear,
        name: 'i_register_0_bit_field_0_clear', direction: :in, width: 1
      )

      expect(bit_fields[1]).to have_port(
        :register_block, :clear,
        name: 'i_register_0_bit_field_1_clear', direction: :in, width: 1
      )

      expect(bit_fields[2]).to have_port(
        :register_block, :clear,
        name: 'i_register_1_bit_field_0_clear', direction: :in, width: 1, array_size: [2]
      )

      expect(bit_fields[3]).to have_port(
        :register_block, :clear,
        name: 'i_register_1_bit_field_1_clear', direction: :in, width: 1, array_size: [2]
      )
    end
  end

  context '参照ビットフィールドを持つ場合' do
    it 'ジェネリクス #use_clearを持たない' do
      expect(bit_fields[4]).to not_have_generic(
        :register_block, :use_clear,
        name: 'REGISTER_2_BIT_FIELD_0_USE_CLEAR', type: :boolean, default: true
      )

      expect(bit_fields[5]).to not_have_generic(
        :register_block, :use_clear,
        name: 'REGISTER_2_BIT_FIELD_1_USE_CLEAR', type: :boolean, default: true
      )
    end

    it '入力ポート#clearを持たない' do
      expect(bit_fields[4]).to not_have_port(
        :register_block, :clear,
        name: 'i_register_2_bit_field_0_clear', direction: :in, width: 1
      )

      expect(bit_fields[5]).to not_have_port(
        :register_block, :clear,
        name: 'i_register_2_bit_field_1_clear', direction: :in, width: 1
      )
    end
  end

  describe '#generate_code' do
    it 'rggen_bit_field_counterをインスタンスするコードを生成する' do
      expect(bit_fields[0]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field_counter
          generic map (
            WIDTH         => 1,
            INITIAL_VALUE => slice(x"0", 1, 0),
            UP_WIDTH      => REGISTER_0_BIT_FIELD_0_UP_WIDTH,
            DOWN_WIDTH    => REGISTER_0_BIT_FIELD_0_DOWN_WIDTH,
            WRAP_AROUND   => REGISTER_0_BIT_FIELD_0_WRAP_AROUND,
            USE_CLEAR     => REGISTER_0_BIT_FIELD_0_USE_CLEAR
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_read_valid   => bit_field_read_valid,
            i_sw_write_valid  => bit_field_write_valid,
            i_sw_mask         => bit_field_mask(0 downto 0),
            i_sw_write_data   => bit_field_write_data(0 downto 0),
            o_sw_read_data    => bit_field_read_data(0 downto 0),
            o_sw_value        => bit_field_value(0 downto 0),
            i_clear           => i_register_0_bit_field_0_clear,
            i_up              => i_register_0_bit_field_0_up,
            i_down            => i_register_0_bit_field_0_down,
            o_count           => o_register_0_bit_field_0
          );
      CODE

      expect(bit_fields[1]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field_counter
          generic map (
            WIDTH         => 8,
            INITIAL_VALUE => slice(x"ab", 8, 0),
            UP_WIDTH      => REGISTER_0_BIT_FIELD_1_UP_WIDTH,
            DOWN_WIDTH    => REGISTER_0_BIT_FIELD_1_DOWN_WIDTH,
            WRAP_AROUND   => REGISTER_0_BIT_FIELD_1_WRAP_AROUND,
            USE_CLEAR     => REGISTER_0_BIT_FIELD_1_USE_CLEAR
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_read_valid   => bit_field_read_valid,
            i_sw_write_valid  => bit_field_write_valid,
            i_sw_mask         => bit_field_mask(15 downto 8),
            i_sw_write_data   => bit_field_write_data(15 downto 8),
            o_sw_read_data    => bit_field_read_data(15 downto 8),
            o_sw_value        => bit_field_value(15 downto 8),
            i_clear           => i_register_0_bit_field_1_clear,
            i_up              => i_register_0_bit_field_1_up,
            i_down            => i_register_0_bit_field_1_down,
            o_count           => o_register_0_bit_field_1
          );
      CODE

      expect(bit_fields[2]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field_counter
          generic map (
            WIDTH         => 1,
            INITIAL_VALUE => slice(x"0", 1, 0),
            UP_WIDTH      => REGISTER_1_BIT_FIELD_0_UP_WIDTH,
            DOWN_WIDTH    => REGISTER_1_BIT_FIELD_0_DOWN_WIDTH,
            WRAP_AROUND   => REGISTER_1_BIT_FIELD_0_WRAP_AROUND,
            USE_CLEAR     => REGISTER_1_BIT_FIELD_0_USE_CLEAR
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_read_valid   => bit_field_read_valid,
            i_sw_write_valid  => bit_field_write_valid,
            i_sw_mask         => bit_field_mask(0 downto 0),
            i_sw_write_data   => bit_field_write_data(0 downto 0),
            o_sw_read_data    => bit_field_read_data(0 downto 0),
            o_sw_value        => bit_field_value(0 downto 0),
            i_clear           => i_register_1_bit_field_0_clear(1*(i)+0 downto 1*(i)),
            i_up              => i_register_1_bit_field_0_up(clip_width(REGISTER_1_BIT_FIELD_0_UP_WIDTH)*(i)+clip_width(REGISTER_1_BIT_FIELD_0_UP_WIDTH)-1 downto clip_width(REGISTER_1_BIT_FIELD_0_UP_WIDTH)*(i)),
            i_down            => i_register_1_bit_field_0_down(clip_width(REGISTER_1_BIT_FIELD_0_DOWN_WIDTH)*(i)+clip_width(REGISTER_1_BIT_FIELD_0_DOWN_WIDTH)-1 downto clip_width(REGISTER_1_BIT_FIELD_0_DOWN_WIDTH)*(i)),
            o_count           => o_register_1_bit_field_0(1*(i)+0 downto 1*(i))
          );
      CODE

      expect(bit_fields[3]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field_counter
          generic map (
            WIDTH         => 8,
            INITIAL_VALUE => slice(x"cd", 8, 0),
            UP_WIDTH      => REGISTER_1_BIT_FIELD_1_UP_WIDTH,
            DOWN_WIDTH    => REGISTER_1_BIT_FIELD_1_DOWN_WIDTH,
            WRAP_AROUND   => REGISTER_1_BIT_FIELD_1_WRAP_AROUND,
            USE_CLEAR     => REGISTER_1_BIT_FIELD_1_USE_CLEAR
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_read_valid   => bit_field_read_valid,
            i_sw_write_valid  => bit_field_write_valid,
            i_sw_mask         => bit_field_mask(15 downto 8),
            i_sw_write_data   => bit_field_write_data(15 downto 8),
            o_sw_read_data    => bit_field_read_data(15 downto 8),
            o_sw_value        => bit_field_value(15 downto 8),
            i_clear           => i_register_1_bit_field_1_clear(1*(i)+0 downto 1*(i)),
            i_up              => i_register_1_bit_field_1_up(clip_width(REGISTER_1_BIT_FIELD_1_UP_WIDTH)*(i)+clip_width(REGISTER_1_BIT_FIELD_1_UP_WIDTH)-1 downto clip_width(REGISTER_1_BIT_FIELD_1_UP_WIDTH)*(i)),
            i_down            => i_register_1_bit_field_1_down(clip_width(REGISTER_1_BIT_FIELD_1_DOWN_WIDTH)*(i)+clip_width(REGISTER_1_BIT_FIELD_1_DOWN_WIDTH)-1 downto clip_width(REGISTER_1_BIT_FIELD_1_DOWN_WIDTH)*(i)),
            o_count           => o_register_1_bit_field_1(8*(i)+7 downto 8*(i))
          );
      CODE

      expect(bit_fields[4]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field_counter
          generic map (
            WIDTH         => 1,
            INITIAL_VALUE => slice(x"0", 1, 0),
            UP_WIDTH      => REGISTER_2_BIT_FIELD_0_UP_WIDTH,
            DOWN_WIDTH    => REGISTER_2_BIT_FIELD_0_DOWN_WIDTH,
            WRAP_AROUND   => REGISTER_2_BIT_FIELD_0_WRAP_AROUND,
            USE_CLEAR     => true
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_read_valid   => bit_field_read_valid,
            i_sw_write_valid  => bit_field_write_valid,
            i_sw_mask         => bit_field_mask(0 downto 0),
            i_sw_write_data   => bit_field_write_data(0 downto 0),
            o_sw_read_data    => bit_field_read_data(0 downto 0),
            o_sw_value        => bit_field_value(0 downto 0),
            i_clear           => register_value(128 downto 128),
            i_up              => i_register_2_bit_field_0_up,
            i_down            => i_register_2_bit_field_0_down,
            o_count           => o_register_2_bit_field_0
          );
      CODE

      expect(bit_fields[5]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field_counter
          generic map (
            WIDTH         => 8,
            INITIAL_VALUE => slice(x"ef", 8, 0),
            UP_WIDTH      => REGISTER_2_BIT_FIELD_1_UP_WIDTH,
            DOWN_WIDTH    => REGISTER_2_BIT_FIELD_1_DOWN_WIDTH,
            WRAP_AROUND   => REGISTER_2_BIT_FIELD_1_WRAP_AROUND,
            USE_CLEAR     => true
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_read_valid   => bit_field_read_valid,
            i_sw_write_valid  => bit_field_write_valid,
            i_sw_mask         => bit_field_mask(15 downto 8),
            i_sw_write_data   => bit_field_write_data(15 downto 8),
            o_sw_read_data    => bit_field_read_data(15 downto 8),
            o_sw_value        => bit_field_value(15 downto 8),
            i_clear           => register_value(128 downto 128),
            i_up              => i_register_2_bit_field_1_up,
            i_down            => i_register_2_bit_field_1_down,
            o_count           => o_register_2_bit_field_1
          );
      CODE
    end
  end
end
