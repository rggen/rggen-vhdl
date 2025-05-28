# frozen_string_literal: true

RSpec.describe 'bit_field/type/wrc' do
  include_context 'clean-up builder'
  include_context 'bit field vhdl common'

  before(:all) do
    RgGen.enable(:bit_field, :type, [:wrc])
  end

  it '出力ポート#value_outを持つ' do
    bit_fields = create_bit_fields do
      byte_size 256

      register do
        name 'register_0'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :wrc; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :wrc; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :wrc; initial_value 0 }
      end

      register do
        name 'register_1'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 64; type :wrc; initial_value 0 }
      end

      register do
        name 'register_2'
        size [4]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :wrc; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :wrc; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :wrc; initial_value 0 }
      end

      register do
        name 'register_3'
        size [2, 2]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :wrc; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :wrc; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :wrc; initial_value 0 }
      end

      register_file do
        name 'register_file_4'
        size [2, 2]
        register_file do
          name 'register_file_0'
          register do
            name 'register_0'
            size [2, 2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :wrc; initial_value 0 }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :wrc; initial_value 0 }
            bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :wrc; initial_value 0 }
          end
        end
      end
    end

    expect(bit_fields[0]).to have_port(
      :register_block, :value_out,
      name: 'o_register_0_bit_field_0', direction: :out, width: 1
    )
    expect(bit_fields[1]).to have_port(
      :register_block, :value_out,
      name: 'o_register_0_bit_field_1', direction: :out, width: 2
    )
    expect(bit_fields[2]).to have_port(
      :register_block, :value_out,
      name: 'o_register_0_bit_field_2', direction: :out, width: 4, array_size: [2]
    )

    expect(bit_fields[3]).to have_port(
      :register_block, :value_out,
      name: 'o_register_1_bit_field_0', direction: :out, width: 64
    )

    expect(bit_fields[4]).to have_port(
      :register_block, :value_out,
      name: 'o_register_2_bit_field_0', direction: :out, width: 1, array_size: [4]
    )
    expect(bit_fields[5]).to have_port(
      :register_block, :value_out,
      name: 'o_register_2_bit_field_1', direction: :out, width: 2, array_size: [4]
    )
    expect(bit_fields[6]).to have_port(
      :register_block, :value_out,
      name: 'o_register_2_bit_field_2', direction: :out, width: 4, array_size: [4, 2]
    )

    expect(bit_fields[7]).to have_port(
      :register_block, :value_out,
      name: 'o_register_3_bit_field_0', direction: :out, width: 1, array_size: [2, 2]
    )
    expect(bit_fields[8]).to have_port(
      :register_block, :value_out,
      name: 'o_register_3_bit_field_1', direction: :out, width: 2, array_size: [2, 2]
    )
    expect(bit_fields[9]).to have_port(
      :register_block, :value_out,
      name: 'o_register_3_bit_field_2', direction: :out, width: 4, array_size: [2, 2, 2]
    )

    expect(bit_fields[10]).to have_port(
      :register_block, :value_out,
      name: 'o_register_file_4_register_file_0_register_0_bit_field_0', direction: :out, width: 1, array_size: [2, 2, 2, 2]
    )
    expect(bit_fields[11]).to have_port(
      :register_block, :value_out,
      name: 'o_register_file_4_register_file_0_register_0_bit_field_1', direction: :out, width: 2, array_size: [2, 2, 2, 2]
    )
    expect(bit_fields[12]).to have_port(
      :register_block, :value_out,
      name: 'o_register_file_4_register_file_0_register_0_bit_field_2', direction: :out, width: 4, array_size: [2, 2, 2, 2, 2]
    )
  end

  describe '#generate_code' do
    it 'rggen_bit_fieldをインスタンスするコードを出力する' do
      bit_fields = create_bit_fields do
        byte_size 256

        register do
          name 'register_0'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :wrc; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 16, width: 16; type :wrc; initial_value 0xabcd }
        end

        register do
          name 'register_1'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 64; type :wrc; initial_value 0 }
        end

        register do
          name 'register_2'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :wrc; initial_value 0 }
        end

        register do
          name 'register_3'
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :wrc; initial_value 0 }
        end

        register do
          name 'register_4'
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :wrc; initial_value 0 }
        end

        register_file do
          name 'register_file_5'
          size [2, 2]
          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :wrc; initial_value 0 }
            end
          end
        end
      end

      expect(bit_fields[0]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field
          generic map (
            WIDTH           => 1,
            INITIAL_VALUE   => slice(x"0", 1, 0),
            SW_READ_ACTION  => RGGEN_READ_CLEAR
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_read_valid   => bit_field_read_valid,
            i_sw_write_valid  => bit_field_write_valid,
            i_sw_write_enable => "1",
            i_sw_mask         => bit_field_mask(0 downto 0),
            i_sw_write_data   => bit_field_write_data(0 downto 0),
            o_sw_read_data    => bit_field_read_data(0 downto 0),
            o_sw_value        => bit_field_value(0 downto 0),
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
            WIDTH           => 16,
            INITIAL_VALUE   => slice(x"abcd", 16, 0),
            SW_READ_ACTION  => RGGEN_READ_CLEAR
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_read_valid   => bit_field_read_valid,
            i_sw_write_valid  => bit_field_write_valid,
            i_sw_write_enable => "1",
            i_sw_mask         => bit_field_mask(31 downto 16),
            i_sw_write_data   => bit_field_write_data(31 downto 16),
            o_sw_read_data    => bit_field_read_data(31 downto 16),
            o_sw_value        => bit_field_value(31 downto 16),
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => "0",
            i_hw_write_data   => (others => '0'),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_0_bit_field_1,
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[2]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field
          generic map (
            WIDTH           => 64,
            INITIAL_VALUE   => slice(x"0000000000000000", 64, 0),
            SW_READ_ACTION  => RGGEN_READ_CLEAR
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_read_valid   => bit_field_read_valid,
            i_sw_write_valid  => bit_field_write_valid,
            i_sw_write_enable => "1",
            i_sw_mask         => bit_field_mask(63 downto 0),
            i_sw_write_data   => bit_field_write_data(63 downto 0),
            o_sw_read_data    => bit_field_read_data(63 downto 0),
            o_sw_value        => bit_field_value(63 downto 0),
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

      expect(bit_fields[3]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field
          generic map (
            WIDTH           => 4,
            INITIAL_VALUE   => slice(x"0", 4, 0),
            SW_READ_ACTION  => RGGEN_READ_CLEAR
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_read_valid   => bit_field_read_valid,
            i_sw_write_valid  => bit_field_write_valid,
            i_sw_write_enable => "1",
            i_sw_mask         => bit_field_mask(0+8*i+3 downto 0+8*i),
            i_sw_write_data   => bit_field_write_data(0+8*i+3 downto 0+8*i),
            o_sw_read_data    => bit_field_read_data(0+8*i+3 downto 0+8*i),
            o_sw_value        => bit_field_value(0+8*i+3 downto 0+8*i),
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => "0",
            i_hw_write_data   => (others => '0'),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_2_bit_field_0(4*(i)+3 downto 4*(i)),
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[4]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field
          generic map (
            WIDTH           => 4,
            INITIAL_VALUE   => slice(x"0", 4, 0),
            SW_READ_ACTION  => RGGEN_READ_CLEAR
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_read_valid   => bit_field_read_valid,
            i_sw_write_valid  => bit_field_write_valid,
            i_sw_write_enable => "1",
            i_sw_mask         => bit_field_mask(0+8*j+3 downto 0+8*j),
            i_sw_write_data   => bit_field_write_data(0+8*j+3 downto 0+8*j),
            o_sw_read_data    => bit_field_read_data(0+8*j+3 downto 0+8*j),
            o_sw_value        => bit_field_value(0+8*j+3 downto 0+8*j),
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => "0",
            i_hw_write_data   => (others => '0'),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_3_bit_field_0(4*(4*i+j)+3 downto 4*(4*i+j)),
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[5]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field
          generic map (
            WIDTH           => 4,
            INITIAL_VALUE   => slice(x"0", 4, 0),
            SW_READ_ACTION  => RGGEN_READ_CLEAR
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_read_valid   => bit_field_read_valid,
            i_sw_write_valid  => bit_field_write_valid,
            i_sw_write_enable => "1",
            i_sw_mask         => bit_field_mask(0+8*k+3 downto 0+8*k),
            i_sw_write_data   => bit_field_write_data(0+8*k+3 downto 0+8*k),
            o_sw_read_data    => bit_field_read_data(0+8*k+3 downto 0+8*k),
            o_sw_value        => bit_field_value(0+8*k+3 downto 0+8*k),
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => "0",
            i_hw_write_data   => (others => '0'),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_4_bit_field_0(4*(8*i+4*j+k)+3 downto 4*(8*i+4*j+k)),
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[6]).to generate_code(:bit_field, :top_down, <<~"CODE")
        u_bit_field: entity #{library_name}.rggen_bit_field
          generic map (
            WIDTH           => 4,
            INITIAL_VALUE   => slice(x"0", 4, 0),
            SW_READ_ACTION  => RGGEN_READ_CLEAR
          )
          port map (
            i_clk             => i_clk,
            i_rst_n           => i_rst_n,
            i_sw_read_valid   => bit_field_read_valid,
            i_sw_write_valid  => bit_field_write_valid,
            i_sw_write_enable => "1",
            i_sw_mask         => bit_field_mask(0+8*m+3 downto 0+8*m),
            i_sw_write_data   => bit_field_write_data(0+8*m+3 downto 0+8*m),
            o_sw_read_data    => bit_field_read_data(0+8*m+3 downto 0+8*m),
            o_sw_value        => bit_field_value(0+8*m+3 downto 0+8*m),
            o_write_trigger   => open,
            o_read_trigger    => open,
            i_hw_write_enable => "0",
            i_hw_write_data   => (others => '0'),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => (others => '0'),
            i_mask            => (others => '1'),
            o_value           => o_register_file_5_register_file_0_register_0_bit_field_0(4*(32*i+16*j+8*k+4*l+m)+3 downto 4*(32*i+16*j+8*k+4*l+m)),
            o_value_unmasked  => open
          );
      CODE
    end
  end
end
