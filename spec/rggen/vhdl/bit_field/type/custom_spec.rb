# frozen_string_literal: true

RSpec.describe 'bit_field/type/custom' do
  include_context 'clean-up builder'
  include_context 'bit field vhdl common'

  before(:all) do
    RgGen.enable(:bit_field, :type, :custom)
  end

  let(:bit_fields) do
    create_bit_fields do
      byte_size 256

      register do
        name 'register_0'
        bit_field { name 'bit_field_0'; bit_assignment width: 2; type [:custom]; initial_value 0 }
      end

      register do
        name 'register_1'
        bit_field { name 'bit_field_0'; bit_assignment width: 2; type [:custom, sw_read: :none]; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment width: 2; type [:custom, sw_read: :default]; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment width: 2; type [:custom, sw_read: :set]; initial_value 0 }
        bit_field { name 'bit_field_3'; bit_assignment width: 2; type [:custom, sw_read: :clear]; initial_value 0 }
      end

      register do
        name 'register_2'
        bit_field { name 'bit_field_0'; bit_assignment width: 2; type [:custom, sw_write: :none] }
        bit_field { name 'bit_field_1'; bit_assignment width: 2; type [:custom, sw_write: :default]; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment width: 2; type [:custom, sw_write: :set]; initial_value 0 }
        bit_field { name 'bit_field_3'; bit_assignment width: 2; type [:custom, sw_write: :set_0]; initial_value 0 }
        bit_field { name 'bit_field_4'; bit_assignment width: 2; type [:custom, sw_write: :set_1]; initial_value 0 }
        bit_field { name 'bit_field_5'; bit_assignment width: 2; type [:custom, sw_write: :clear]; initial_value 0 }
        bit_field { name 'bit_field_6'; bit_assignment width: 2; type [:custom, sw_write: :clear_0]; initial_value 0 }
        bit_field { name 'bit_field_7'; bit_assignment width: 2; type [:custom, sw_write: :clear_1]; initial_value 0 }
        bit_field { name 'bit_field_8'; bit_assignment width: 2; type [:custom, sw_write: :toggle_0]; initial_value 0 }
        bit_field { name 'bit_field_9'; bit_assignment width: 2; type [:custom, sw_write: :toggle_1]; initial_value 0 }
      end

      register do
        name 'register_3'
        bit_field { name 'bit_field_0'; bit_assignment width: 2; type [:custom, sw_write_once: true]; initial_value 0 }
      end

      register do
        name 'register_4'
        bit_field { name 'bit_field_0'; bit_assignment width: 2; type [:custom, hw_write: true]; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment width: 2; type [:custom, hw_set: true]; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment width: 2; type [:custom, hw_clear: true]; initial_value 0 }
      end

      register do
        name 'register_5'
        bit_field { name 'bit_field_0'; bit_assignment width: 2; type [:custom, write_trigger: true]; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment width: 2; type [:custom, read_trigger: true]; initial_value 0 }
      end
    end
  end

  def match_bit_fields(*name, &block)
    bit_fields
      .select { |b| [b.register.name, b.name] == name }
      .each(&block)
  end

  def unmatch_bit_fields(*name, &block)
    bit_fields
      .reject { |b| [b.register.name, b.name] == name }
      .each(&block)
  end

  context 'SWまたはHWからの更新がある場合' do
    it '出力ポート#value_outを持つ' do
      unmatch_bit_fields('register_2', 'bit_field_0') do |bit_field|
        expect(bit_field).to have_port(
          :register_block, :value_out,
          name: "o_#{bit_field.full_name('_')}", direction: :out, width: 2
        )
      end

      match_bit_fields('register_2', 'bit_field_0') do |bit_field|
        expect(bit_field).to not_have_port(
          :register_block, :value_out,
          name: "o_#{bit_field.full_name('_')}", direction: :out, width: 2
        )
      end
    end
  end

  context 'SW/HWからの更新が共にない場合' do
    it '入力ポート#value_inを持つ' do
      match_bit_fields('register_2', 'bit_field_0') do |bit_field|
        expect(bit_field).to have_port(
          :register_block, :value_in,
          name: "i_#{bit_field.full_name('_')}", direction: :in, width: 2
        )
      end

      unmatch_bit_fields('register_2', 'bit_field_0') do |bit_field|
        expect(bit_field).to not_have_port(
          :register_block, :value_in,
          name: "i_#{bit_field.full_name('_')}", direction: :in, width: 2
        )
      end
    end
  end

  context 'hw_writeが有効になっている場合' do
    it '入力ポート#hw_write_enable/#hw_write_dataを持つ' do
      match_bit_fields('register_4', 'bit_field_0') do |bit_field|
        expect(bit_field).to have_port(
          :register_block, :hw_write_enable,
          name: "i_#{bit_field.full_name('_')}_hw_write_enable", direction: :in, width: 1
        )
        expect(bit_field).to have_port(
          :register_block, :hw_write_data,
          name: "i_#{bit_field.full_name('_')}_hw_write_data", direction: :in, width: 2
        )
      end

      unmatch_bit_fields('register_4', 'bit_field_0') do |bit_field|
        expect(bit_field).to not_have_port(
          :register_block, :hw_write_enable,
          name: "i_#{bit_field.full_name('_')}_hw_write_enable", direction: :in, width: 1
        )
        expect(bit_field).to not_have_port(
          :register_block, :hw_write_data,
          name: "i_#{bit_field.full_name('_')}_hw_write_data", direction: :in, width: 2
        )
      end
    end
  end

  context 'hw_setが有効なっている場合' do
    it '入力ポート#hw_setを持つ' do
      match_bit_fields('register_4', 'bit_field_1') do |bit_field|
        expect(bit_field).to have_port(
          :register_block, :hw_set,
          name: "i_#{bit_field.full_name('_')}_hw_set", direction: :in, width: 2
        )
      end

      unmatch_bit_fields('register_4', 'bit_field_1') do |bit_field|
        expect(bit_field).to not_have_port(
          :register_block, :hw_set,
          name: "i_#{bit_field.full_name('_')}_hw_set", direction: :in, width: 2
        )
      end
    end
  end

  context 'hw_clearが有効なっている場合' do
    it '入力ポート#hw_clearを持つ' do
      match_bit_fields('register_4', 'bit_field_2') do |bit_field|
        expect(bit_field).to have_port(
          :register_block, :hw_clear,
          name: "i_#{bit_field.full_name('_')}_hw_clear", direction: :in, width: 2
        )
      end

      unmatch_bit_fields('register_4', 'bit_field_2') do |bit_field|
        expect(bit_field).to not_have_port(
          :register_block, :hw_clear,
          name: "i_#{bit_field.full_name('_')}_hw_clear", direction: :in, width: 2
        )
      end
    end
  end

  context 'write_triggerが有効になっている場合' do
    it '出力ポート#write_triggerを持つ' do
      match_bit_fields('register_5', 'bit_field_0') do |bit_field|
        expect(bit_field).to have_port(
          :register_block, :write_trigger,
          name: "o_#{bit_field.full_name('_')}_write_trigger", direction: :out, width: 1
        )
      end

      unmatch_bit_fields('register_5', 'bit_field_0') do |bit_field|
        expect(bit_field).to not_have_port(
          :register_block, :write_trigger,
          name: "o_#{bit_field.full_name('_')}_write_trigger", direction: :out, width: 1
        )
      end
    end
  end

  context 'read_triggerが有効になっている場合' do
    it '出力ポート#read_triggerを持つ' do
      match_bit_fields('register_5', 'bit_field_1') do |bit_field|
        expect(bit_field).to have_port(
          :register_block, :read_trigger,
          name: "o_#{bit_field.full_name('_')}_read_trigger", direction: :out, width: 1
        )
      end

      unmatch_bit_fields('register_5', 'bit_field_1') do |bit_field|
        expect(bit_field).to not_have_port(
          :register_block, :read_trigger,
          name: "o_#{bit_field.full_name('_')}_read_trigger", direction: :out, width: 1
        )
      end
    end
  end

  describe '#generate_code' do
    let(:array_port_format) { :packed }

    it 'rggen_bit_fieldをインスタンスするコードを生成する' do
      expect(bit_fields[0]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field
          generic map (
            WIDTH               => 2,
            INITIAL_VALUE       => slice(x"0", 2, 0),
            SW_READ_ACTION      => RGGEN_READ_DEFAULT,
            SW_WRITE_ACTION     => RGGEN_WRITE_DEFAULT,
            SW_WRITE_ONCE       => false,
            HW_SET_WIDTH        => 2,
            HW_CLEAR_WIDTH      => 2,
            STORAGE             => true,
            EXTERNAL_READ_DATA  => false,
            TRIGGER             => false
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(1 downto 0),
            i_sw_write_enable => "1",
            i_sw_write_mask   => bit_field_write_mask(1 downto 0),
            i_sw_write_data   => bit_field_write_data(1 downto 0),
            o_sw_read_data    => bit_field_read_data(1 downto 0),
            o_sw_value        => bit_field_value(1 downto 0),
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => "0",
            i_hw_write_data   => (others => '0'),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_0_bit_field_0,
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[1]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field
          generic map (
            WIDTH               => 2,
            INITIAL_VALUE       => slice(x"0", 2, 0),
            SW_READ_ACTION      => RGGEN_READ_NONE,
            SW_WRITE_ACTION     => RGGEN_WRITE_DEFAULT,
            SW_WRITE_ONCE       => false,
            HW_SET_WIDTH        => 2,
            HW_CLEAR_WIDTH      => 2,
            STORAGE             => true,
            EXTERNAL_READ_DATA  => false,
            TRIGGER             => false
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(1 downto 0),
            i_sw_write_enable => "1",
            i_sw_write_mask   => bit_field_write_mask(1 downto 0),
            i_sw_write_data   => bit_field_write_data(1 downto 0),
            o_sw_read_data    => bit_field_read_data(1 downto 0),
            o_sw_value        => bit_field_value(1 downto 0),
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => "0",
            i_hw_write_data   => (others => '0'),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_1_bit_field_0,
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[2]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field
          generic map (
            WIDTH               => 2,
            INITIAL_VALUE       => slice(x"0", 2, 0),
            SW_READ_ACTION      => RGGEN_READ_DEFAULT,
            SW_WRITE_ACTION     => RGGEN_WRITE_DEFAULT,
            SW_WRITE_ONCE       => false,
            HW_SET_WIDTH        => 2,
            HW_CLEAR_WIDTH      => 2,
            STORAGE             => true,
            EXTERNAL_READ_DATA  => false,
            TRIGGER             => false
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(3 downto 2),
            i_sw_write_enable => "1",
            i_sw_write_mask   => bit_field_write_mask(3 downto 2),
            i_sw_write_data   => bit_field_write_data(3 downto 2),
            o_sw_read_data    => bit_field_read_data(3 downto 2),
            o_sw_value        => bit_field_value(3 downto 2),
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => "0",
            i_hw_write_data   => (others => '0'),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_1_bit_field_1,
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[3]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field
          generic map (
            WIDTH               => 2,
            INITIAL_VALUE       => slice(x"0", 2, 0),
            SW_READ_ACTION      => RGGEN_READ_SET,
            SW_WRITE_ACTION     => RGGEN_WRITE_DEFAULT,
            SW_WRITE_ONCE       => false,
            HW_SET_WIDTH        => 2,
            HW_CLEAR_WIDTH      => 2,
            STORAGE             => true,
            EXTERNAL_READ_DATA  => false,
            TRIGGER             => false
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
            i_hw_write_enable => "0",
            i_hw_write_data   => (others => '0'),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_1_bit_field_2,
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[4]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field
          generic map (
            WIDTH               => 2,
            INITIAL_VALUE       => slice(x"0", 2, 0),
            SW_READ_ACTION      => RGGEN_READ_CLEAR,
            SW_WRITE_ACTION     => RGGEN_WRITE_DEFAULT,
            SW_WRITE_ONCE       => false,
            HW_SET_WIDTH        => 2,
            HW_CLEAR_WIDTH      => 2,
            STORAGE             => true,
            EXTERNAL_READ_DATA  => false,
            TRIGGER             => false
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
            i_hw_write_enable => "0",
            i_hw_write_data   => (others => '0'),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_1_bit_field_3,
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[5]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field
          generic map (
            WIDTH               => 2,
            INITIAL_VALUE       => slice(x"0", 2, 0),
            SW_READ_ACTION      => RGGEN_READ_DEFAULT,
            SW_WRITE_ACTION     => RGGEN_WRITE_NONE,
            SW_WRITE_ONCE       => false,
            HW_SET_WIDTH        => 2,
            HW_CLEAR_WIDTH      => 2,
            STORAGE             => false,
            EXTERNAL_READ_DATA  => true,
            TRIGGER             => false
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(1 downto 0),
            i_sw_write_enable => "1",
            i_sw_write_mask   => bit_field_write_mask(1 downto 0),
            i_sw_write_data   => bit_field_write_data(1 downto 0),
            o_sw_read_data    => bit_field_read_data(1 downto 0),
            o_sw_value        => bit_field_value(1 downto 0),
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => "0",
            i_hw_write_data   => (others => '0'),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => i_register_2_bit_field_0,
            i_mask            => (others => '1'),
            o_value           => open,
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[6]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field
          generic map (
            WIDTH               => 2,
            INITIAL_VALUE       => slice(x"0", 2, 0),
            SW_READ_ACTION      => RGGEN_READ_DEFAULT,
            SW_WRITE_ACTION     => RGGEN_WRITE_DEFAULT,
            SW_WRITE_ONCE       => false,
            HW_SET_WIDTH        => 2,
            HW_CLEAR_WIDTH      => 2,
            STORAGE             => true,
            EXTERNAL_READ_DATA  => false,
            TRIGGER             => false
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(3 downto 2),
            i_sw_write_enable => "1",
            i_sw_write_mask   => bit_field_write_mask(3 downto 2),
            i_sw_write_data   => bit_field_write_data(3 downto 2),
            o_sw_read_data    => bit_field_read_data(3 downto 2),
            o_sw_value        => bit_field_value(3 downto 2),
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => "0",
            i_hw_write_data   => (others => '0'),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_2_bit_field_1,
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[7]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field
          generic map (
            WIDTH               => 2,
            INITIAL_VALUE       => slice(x"0", 2, 0),
            SW_READ_ACTION      => RGGEN_READ_DEFAULT,
            SW_WRITE_ACTION     => RGGEN_WRITE_SET,
            SW_WRITE_ONCE       => false,
            HW_SET_WIDTH        => 2,
            HW_CLEAR_WIDTH      => 2,
            STORAGE             => true,
            EXTERNAL_READ_DATA  => false,
            TRIGGER             => false
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
            i_hw_write_enable => "0",
            i_hw_write_data   => (others => '0'),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_2_bit_field_2,
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[8]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field
          generic map (
            WIDTH               => 2,
            INITIAL_VALUE       => slice(x"0", 2, 0),
            SW_READ_ACTION      => RGGEN_READ_DEFAULT,
            SW_WRITE_ACTION     => RGGEN_WRITE_0_SET,
            SW_WRITE_ONCE       => false,
            HW_SET_WIDTH        => 2,
            HW_CLEAR_WIDTH      => 2,
            STORAGE             => true,
            EXTERNAL_READ_DATA  => false,
            TRIGGER             => false
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
            i_hw_write_enable => "0",
            i_hw_write_data   => (others => '0'),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_2_bit_field_3,
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[9]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field
          generic map (
            WIDTH               => 2,
            INITIAL_VALUE       => slice(x"0", 2, 0),
            SW_READ_ACTION      => RGGEN_READ_DEFAULT,
            SW_WRITE_ACTION     => RGGEN_WRITE_1_SET,
            SW_WRITE_ONCE       => false,
            HW_SET_WIDTH        => 2,
            HW_CLEAR_WIDTH      => 2,
            STORAGE             => true,
            EXTERNAL_READ_DATA  => false,
            TRIGGER             => false
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(9 downto 8),
            i_sw_write_enable => "1",
            i_sw_write_mask   => bit_field_write_mask(9 downto 8),
            i_sw_write_data   => bit_field_write_data(9 downto 8),
            o_sw_read_data    => bit_field_read_data(9 downto 8),
            o_sw_value        => bit_field_value(9 downto 8),
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => "0",
            i_hw_write_data   => (others => '0'),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_2_bit_field_4,
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[10]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field
          generic map (
            WIDTH               => 2,
            INITIAL_VALUE       => slice(x"0", 2, 0),
            SW_READ_ACTION      => RGGEN_READ_DEFAULT,
            SW_WRITE_ACTION     => RGGEN_WRITE_CLEAR,
            SW_WRITE_ONCE       => false,
            HW_SET_WIDTH        => 2,
            HW_CLEAR_WIDTH      => 2,
            STORAGE             => true,
            EXTERNAL_READ_DATA  => false,
            TRIGGER             => false
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(11 downto 10),
            i_sw_write_enable => "1",
            i_sw_write_mask   => bit_field_write_mask(11 downto 10),
            i_sw_write_data   => bit_field_write_data(11 downto 10),
            o_sw_read_data    => bit_field_read_data(11 downto 10),
            o_sw_value        => bit_field_value(11 downto 10),
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => "0",
            i_hw_write_data   => (others => '0'),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_2_bit_field_5,
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[11]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field
          generic map (
            WIDTH               => 2,
            INITIAL_VALUE       => slice(x"0", 2, 0),
            SW_READ_ACTION      => RGGEN_READ_DEFAULT,
            SW_WRITE_ACTION     => RGGEN_WRITE_0_CLEAR,
            SW_WRITE_ONCE       => false,
            HW_SET_WIDTH        => 2,
            HW_CLEAR_WIDTH      => 2,
            STORAGE             => true,
            EXTERNAL_READ_DATA  => false,
            TRIGGER             => false
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(13 downto 12),
            i_sw_write_enable => "1",
            i_sw_write_mask   => bit_field_write_mask(13 downto 12),
            i_sw_write_data   => bit_field_write_data(13 downto 12),
            o_sw_read_data    => bit_field_read_data(13 downto 12),
            o_sw_value        => bit_field_value(13 downto 12),
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => "0",
            i_hw_write_data   => (others => '0'),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_2_bit_field_6,
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[12]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field
          generic map (
            WIDTH               => 2,
            INITIAL_VALUE       => slice(x"0", 2, 0),
            SW_READ_ACTION      => RGGEN_READ_DEFAULT,
            SW_WRITE_ACTION     => RGGEN_WRITE_1_CLEAR,
            SW_WRITE_ONCE       => false,
            HW_SET_WIDTH        => 2,
            HW_CLEAR_WIDTH      => 2,
            STORAGE             => true,
            EXTERNAL_READ_DATA  => false,
            TRIGGER             => false
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(15 downto 14),
            i_sw_write_enable => "1",
            i_sw_write_mask   => bit_field_write_mask(15 downto 14),
            i_sw_write_data   => bit_field_write_data(15 downto 14),
            o_sw_read_data    => bit_field_read_data(15 downto 14),
            o_sw_value        => bit_field_value(15 downto 14),
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => "0",
            i_hw_write_data   => (others => '0'),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_2_bit_field_7,
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[13]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field
          generic map (
            WIDTH               => 2,
            INITIAL_VALUE       => slice(x"0", 2, 0),
            SW_READ_ACTION      => RGGEN_READ_DEFAULT,
            SW_WRITE_ACTION     => RGGEN_WRITE_0_TOGGLE,
            SW_WRITE_ONCE       => false,
            HW_SET_WIDTH        => 2,
            HW_CLEAR_WIDTH      => 2,
            STORAGE             => true,
            EXTERNAL_READ_DATA  => false,
            TRIGGER             => false
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(17 downto 16),
            i_sw_write_enable => "1",
            i_sw_write_mask   => bit_field_write_mask(17 downto 16),
            i_sw_write_data   => bit_field_write_data(17 downto 16),
            o_sw_read_data    => bit_field_read_data(17 downto 16),
            o_sw_value        => bit_field_value(17 downto 16),
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => "0",
            i_hw_write_data   => (others => '0'),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_2_bit_field_8,
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[14]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field
          generic map (
            WIDTH               => 2,
            INITIAL_VALUE       => slice(x"0", 2, 0),
            SW_READ_ACTION      => RGGEN_READ_DEFAULT,
            SW_WRITE_ACTION     => RGGEN_WRITE_1_TOGGLE,
            SW_WRITE_ONCE       => false,
            HW_SET_WIDTH        => 2,
            HW_CLEAR_WIDTH      => 2,
            STORAGE             => true,
            EXTERNAL_READ_DATA  => false,
            TRIGGER             => false
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(19 downto 18),
            i_sw_write_enable => "1",
            i_sw_write_mask   => bit_field_write_mask(19 downto 18),
            i_sw_write_data   => bit_field_write_data(19 downto 18),
            o_sw_read_data    => bit_field_read_data(19 downto 18),
            o_sw_value        => bit_field_value(19 downto 18),
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => "0",
            i_hw_write_data   => (others => '0'),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_2_bit_field_9,
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[15]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field
          generic map (
            WIDTH               => 2,
            INITIAL_VALUE       => slice(x"0", 2, 0),
            SW_READ_ACTION      => RGGEN_READ_DEFAULT,
            SW_WRITE_ACTION     => RGGEN_WRITE_DEFAULT,
            SW_WRITE_ONCE       => true,
            HW_SET_WIDTH        => 2,
            HW_CLEAR_WIDTH      => 2,
            STORAGE             => true,
            EXTERNAL_READ_DATA  => false,
            TRIGGER             => false
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(1 downto 0),
            i_sw_write_enable => "1",
            i_sw_write_mask   => bit_field_write_mask(1 downto 0),
            i_sw_write_data   => bit_field_write_data(1 downto 0),
            o_sw_read_data    => bit_field_read_data(1 downto 0),
            o_sw_value        => bit_field_value(1 downto 0),
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => "0",
            i_hw_write_data   => (others => '0'),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_3_bit_field_0,
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[16]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field
          generic map (
            WIDTH               => 2,
            INITIAL_VALUE       => slice(x"0", 2, 0),
            SW_READ_ACTION      => RGGEN_READ_DEFAULT,
            SW_WRITE_ACTION     => RGGEN_WRITE_DEFAULT,
            SW_WRITE_ONCE       => false,
            HW_SET_WIDTH        => 2,
            HW_CLEAR_WIDTH      => 2,
            STORAGE             => true,
            EXTERNAL_READ_DATA  => false,
            TRIGGER             => false
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(1 downto 0),
            i_sw_write_enable => "1",
            i_sw_write_mask   => bit_field_write_mask(1 downto 0),
            i_sw_write_data   => bit_field_write_data(1 downto 0),
            o_sw_read_data    => bit_field_read_data(1 downto 0),
            o_sw_value        => bit_field_value(1 downto 0),
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => i_register_4_bit_field_0_hw_write_enable,
            i_hw_write_data   => i_register_4_bit_field_0_hw_write_data,
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_4_bit_field_0,
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[17]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field
          generic map (
            WIDTH               => 2,
            INITIAL_VALUE       => slice(x"0", 2, 0),
            SW_READ_ACTION      => RGGEN_READ_DEFAULT,
            SW_WRITE_ACTION     => RGGEN_WRITE_DEFAULT,
            SW_WRITE_ONCE       => false,
            HW_SET_WIDTH        => 2,
            HW_CLEAR_WIDTH      => 2,
            STORAGE             => true,
            EXTERNAL_READ_DATA  => false,
            TRIGGER             => false
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(3 downto 2),
            i_sw_write_enable => "1",
            i_sw_write_mask   => bit_field_write_mask(3 downto 2),
            i_sw_write_data   => bit_field_write_data(3 downto 2),
            o_sw_read_data    => bit_field_read_data(3 downto 2),
            o_sw_value        => bit_field_value(3 downto 2),
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => "0",
            i_hw_write_data   => (others => '0'),
            i_hw_set          => i_register_4_bit_field_1_hw_set,
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_4_bit_field_1,
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[18]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field
          generic map (
            WIDTH               => 2,
            INITIAL_VALUE       => slice(x"0", 2, 0),
            SW_READ_ACTION      => RGGEN_READ_DEFAULT,
            SW_WRITE_ACTION     => RGGEN_WRITE_DEFAULT,
            SW_WRITE_ONCE       => false,
            HW_SET_WIDTH        => 2,
            HW_CLEAR_WIDTH      => 2,
            STORAGE             => true,
            EXTERNAL_READ_DATA  => false,
            TRIGGER             => false
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
            i_hw_write_enable => "0",
            i_hw_write_data   => (others => '0'),
            i_hw_set          => (others => '0'),
            i_hw_clear        => i_register_4_bit_field_2_hw_clear,
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_4_bit_field_2,
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[19]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field
          generic map (
            WIDTH               => 2,
            INITIAL_VALUE       => slice(x"0", 2, 0),
            SW_READ_ACTION      => RGGEN_READ_DEFAULT,
            SW_WRITE_ACTION     => RGGEN_WRITE_DEFAULT,
            SW_WRITE_ONCE       => false,
            HW_SET_WIDTH        => 2,
            HW_CLEAR_WIDTH      => 2,
            STORAGE             => true,
            EXTERNAL_READ_DATA  => false,
            TRIGGER             => true
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(1 downto 0),
            i_sw_write_enable => "1",
            i_sw_write_mask   => bit_field_write_mask(1 downto 0),
            i_sw_write_data   => bit_field_write_data(1 downto 0),
            o_sw_read_data    => bit_field_read_data(1 downto 0),
            o_sw_value        => bit_field_value(1 downto 0),
            o_write_trigger   => o_register_5_bit_field_0_write_trigger,
            o_read_trigger    => open,
            i_hw_write_enable => "0",
            i_hw_write_data   => (others => '0'),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_5_bit_field_0,
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[20]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field
          generic map (
            WIDTH               => 2,
            INITIAL_VALUE       => slice(x"0", 2, 0),
            SW_READ_ACTION      => RGGEN_READ_DEFAULT,
            SW_WRITE_ACTION     => RGGEN_WRITE_DEFAULT,
            SW_WRITE_ONCE       => false,
            HW_SET_WIDTH        => 2,
            HW_CLEAR_WIDTH      => 2,
            STORAGE             => true,
            EXTERNAL_READ_DATA  => false,
            TRIGGER             => true
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(3 downto 2),
            i_sw_write_enable => "1",
            i_sw_write_mask   => bit_field_write_mask(3 downto 2),
            i_sw_write_data   => bit_field_write_data(3 downto 2),
            o_sw_read_data    => bit_field_read_data(3 downto 2),
            o_sw_value        => bit_field_value(3 downto 2),
            o_write_trigger   => open,
            o_read_trigger    => o_register_5_bit_field_1_read_trigger,
            i_hw_write_enable => "0",
            i_hw_write_data   => (others => '0'),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_5_bit_field_1,
            o_value_unmasked  => open
          );
      CODE
    end
  end
end
