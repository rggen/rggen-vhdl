# frozen_string_literal: true

RSpec.describe 'register/type/indirect' do
  include_context 'clean-up builder'
  include_context 'vhdl common'

  before(:all) do
    RgGen.enable(:global, [:address_width, :enable_wide_register, :library_name])
    RgGen.enable(:register_block, [:byte_size, :bus_width])
    RgGen.enable(:register_file, [:name, :offset_address, :size])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:register, :type, [:indirect])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :initial_value, :reference, :type])
    RgGen.enable(:bit_field, :type, [:ro, :rw, :wo, :reserved])
    RgGen.enable(:register_block, :vhdl_top)
    RgGen.enable(:register_file, :vhdl_top)
    RgGen.enable(:register, :vhdl_top)
    RgGen.enable(:bit_field, :vhdl_top)
  end

  let(:library_name) do
    ['work', 'foo_lib'].sample
  end

  let(:configuration) do
    create_configuration(library_name: library_name)
  end

  let(:registers) do
    vhdl = create_vhdl(configuration) do
      byte_size 256

      register do
        name 'register_0'
        offset_address 0x00
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rw; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4; type :rw; initial_value 0 }
      end

      register do
        name 'register_1'
        offset_address 0x04
        bit_field { bit_assignment lsb: 0, width: 2; type :rw; initial_value 0 }
      end

      register do
        name 'register_2'
        offset_address 0x08
        bit_field { bit_assignment lsb: 0, width: 2; type :rw; initial_value 0 }
      end

      register_file do
        name 'register_file_3'
        offset_address 0x0C
        register do
          name 'register_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4; type :rw; initial_value 0 }
        end
      end

      register do
        name 'register_4'
        offset_address 0x10
        type [:indirect, ['register_0.bit_field_0', 1]]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_5'
        offset_address 0x14
        size [2]
        type [:indirect, 'register_0.bit_field_1']
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_6'
        offset_address 0x18
        size [2, 4]
        type [:indirect, 'register_0.bit_field_1', 'register_0.bit_field_2']
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_7'
        offset_address 0x1c
        size [2, 4]
        type [:indirect, ['register_0.bit_field_0', 0], 'register_0.bit_field_1', 'register_0.bit_field_2']
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_8'
        offset_address 0x20
        type [:indirect, ['register_0.bit_field_0', 0]]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :ro }
      end

      register do
        name 'register_9'
        offset_address 0x24
        type [:indirect, ['register_0.bit_field_0', 0]]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :wo; initial_value 0 }
      end

      register do
        name 'register_10'
        offset_address 0x28
        size [2]
        type [:indirect, 'register_1', ['register_2', 0]]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_11'
        offset_address 0x2C
        size [2, 4]
        type [
          :indirect,
          ['register_file_3.register_0.bit_field_0', 0],
          'register_file_3.register_0.bit_field_1',
          'register_file_3.register_0.bit_field_2'
        ]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register_file do
        name 'register_file_12'
        offset_address 0x30
        size [2, 2]
        register_file do
          name 'register_file_0'
          offset_address 0x00

          register do
            name 'register_0'
            offset_address 0x00
            size [2, 4]
            type [
              :indirect,
              ['register_0.bit_field_0', 0],
              'register_0.bit_field_1',
              'register_0.bit_field_2'
            ]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end

          register do
            name 'register_1'
            offset_address 0x04
            size [2, 4]
            type [
              :indirect,
              ['register_file_3.register_0.bit_field_0', 0],
              'register_file_3.register_0.bit_field_1',
              'register_file_3.register_0.bit_field_2'
            ]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end
        end
      end
    end
    vhdl.registers
  end

  it '間接アクセス用インデックス一致#indirect_matchを持つ' do
    expect(registers[4]).to have_signal(
      :indirect_match,
      name: 'indirect_match', width: 1
    )
    expect(registers[5]).to have_signal(
      :indirect_match,
      name: 'indirect_match', width: 1
    )
    expect(registers[6]).to have_signal(
      :indirect_match,
      name: 'indirect_match', width: 2
    )
    expect(registers[7]).to have_signal(
      :indirect_match,
      name: 'indirect_match', width: 3
    )
  end

  describe '#generate_code' do
    it 'rggen_indirect_registerをインスタンスするコードを出力する' do
      expect(registers[4]).to generate_code(:register, :top_down, <<~"CODE")
        \\g_tie_off\\: for \\__i\\ in 0 to 31 generate
          g: if (bit_slice(x"00000001", \\__i\\) = '0') generate
            bit_field_read_data(\\__i\\) <= '0';
            bit_field_value(\\__i\\) <= '0';
          end generate;
        end generate;
        indirect_match(0) <= '1' when unsigned(register_value(0 downto 0)) = 1 else '0';
        u_register: entity #{library_name}.rggen_indirect_register
          generic map (
            READABLE              => true,
            WRITABLE              => true,
            ADDRESS_WIDTH         => 8,
            OFFSET_ADDRESS        => x"10",
            BUS_WIDTH             => 32,
            DATA_WIDTH            => 32,
            INDIRECT_MATCH_WIDTH  => 1
          )
          port map (
            i_clk                   => i_clk,
            i_rst_n                 => i_rst_n,
            i_register_valid        => register_valid,
            i_register_access       => register_access,
            i_register_address      => register_address,
            i_register_write_data   => register_write_data,
            i_register_strobe       => register_strobe,
            o_register_active       => register_active(4),
            o_register_ready        => register_ready(4),
            o_register_status       => register_status(9 downto 8),
            o_register_read_data    => register_read_data(159 downto 128),
            o_register_value        => register_value(159 downto 128),
            i_indirect_match        => indirect_match,
            o_bit_field_valid       => bit_field_valid,
            o_bit_field_read_mask   => bit_field_read_mask,
            o_bit_field_write_mask  => bit_field_write_mask,
            o_bit_field_write_data  => bit_field_write_data,
            i_bit_field_read_data   => bit_field_read_data,
            i_bit_field_value       => bit_field_value
          );
      CODE

      expect(registers[5]).to generate_code(:register, :top_down, <<~"CODE")
        \\g_tie_off\\: for \\__i\\ in 0 to 31 generate
          g: if (bit_slice(x"00000001", \\__i\\) = '0') generate
            bit_field_read_data(\\__i\\) <= '0';
            bit_field_value(\\__i\\) <= '0';
          end generate;
        end generate;
        indirect_match(0) <= '1' when unsigned(register_value(9 downto 8)) = i else '0';
        u_register: entity #{library_name}.rggen_indirect_register
          generic map (
            READABLE              => true,
            WRITABLE              => true,
            ADDRESS_WIDTH         => 8,
            OFFSET_ADDRESS        => x"14",
            BUS_WIDTH             => 32,
            DATA_WIDTH            => 32,
            INDIRECT_MATCH_WIDTH  => 1
          )
          port map (
            i_clk                   => i_clk,
            i_rst_n                 => i_rst_n,
            i_register_valid        => register_valid,
            i_register_access       => register_access,
            i_register_address      => register_address,
            i_register_write_data   => register_write_data,
            i_register_strobe       => register_strobe,
            o_register_active       => register_active(5+i),
            o_register_ready        => register_ready(5+i),
            o_register_status       => register_status(2*(5+i)+1 downto 2*(5+i)),
            o_register_read_data    => register_read_data(32*(5+i)+31 downto 32*(5+i)),
            o_register_value        => register_value(32*(5+i)+0+31 downto 32*(5+i)+0),
            i_indirect_match        => indirect_match,
            o_bit_field_valid       => bit_field_valid,
            o_bit_field_read_mask   => bit_field_read_mask,
            o_bit_field_write_mask  => bit_field_write_mask,
            o_bit_field_write_data  => bit_field_write_data,
            i_bit_field_read_data   => bit_field_read_data,
            i_bit_field_value       => bit_field_value
          );
      CODE

      expect(registers[6]).to generate_code(:register, :top_down, <<~"CODE")
        \\g_tie_off\\: for \\__i\\ in 0 to 31 generate
          g: if (bit_slice(x"00000001", \\__i\\) = '0') generate
            bit_field_read_data(\\__i\\) <= '0';
            bit_field_value(\\__i\\) <= '0';
          end generate;
        end generate;
        indirect_match(0) <= '1' when unsigned(register_value(9 downto 8)) = i else '0';
        indirect_match(1) <= '1' when unsigned(register_value(19 downto 16)) = j else '0';
        u_register: entity #{library_name}.rggen_indirect_register
          generic map (
            READABLE              => true,
            WRITABLE              => true,
            ADDRESS_WIDTH         => 8,
            OFFSET_ADDRESS        => x"18",
            BUS_WIDTH             => 32,
            DATA_WIDTH            => 32,
            INDIRECT_MATCH_WIDTH  => 2
          )
          port map (
            i_clk                   => i_clk,
            i_rst_n                 => i_rst_n,
            i_register_valid        => register_valid,
            i_register_access       => register_access,
            i_register_address      => register_address,
            i_register_write_data   => register_write_data,
            i_register_strobe       => register_strobe,
            o_register_active       => register_active(7+4*i+j),
            o_register_ready        => register_ready(7+4*i+j),
            o_register_status       => register_status(2*(7+4*i+j)+1 downto 2*(7+4*i+j)),
            o_register_read_data    => register_read_data(32*(7+4*i+j)+31 downto 32*(7+4*i+j)),
            o_register_value        => register_value(32*(7+4*i+j)+0+31 downto 32*(7+4*i+j)+0),
            i_indirect_match        => indirect_match,
            o_bit_field_valid       => bit_field_valid,
            o_bit_field_read_mask   => bit_field_read_mask,
            o_bit_field_write_mask  => bit_field_write_mask,
            o_bit_field_write_data  => bit_field_write_data,
            i_bit_field_read_data   => bit_field_read_data,
            i_bit_field_value       => bit_field_value
          );
      CODE

      expect(registers[7]).to generate_code(:register, :top_down, <<~"CODE")
        \\g_tie_off\\: for \\__i\\ in 0 to 31 generate
          g: if (bit_slice(x"00000001", \\__i\\) = '0') generate
            bit_field_read_data(\\__i\\) <= '0';
            bit_field_value(\\__i\\) <= '0';
          end generate;
        end generate;
        indirect_match(0) <= '1' when unsigned(register_value(0 downto 0)) = 0 else '0';
        indirect_match(1) <= '1' when unsigned(register_value(9 downto 8)) = i else '0';
        indirect_match(2) <= '1' when unsigned(register_value(19 downto 16)) = j else '0';
        u_register: entity #{library_name}.rggen_indirect_register
          generic map (
            READABLE              => true,
            WRITABLE              => true,
            ADDRESS_WIDTH         => 8,
            OFFSET_ADDRESS        => x"1c",
            BUS_WIDTH             => 32,
            DATA_WIDTH            => 32,
            INDIRECT_MATCH_WIDTH  => 3
          )
          port map (
            i_clk                   => i_clk,
            i_rst_n                 => i_rst_n,
            i_register_valid        => register_valid,
            i_register_access       => register_access,
            i_register_address      => register_address,
            i_register_write_data   => register_write_data,
            i_register_strobe       => register_strobe,
            o_register_active       => register_active(15+4*i+j),
            o_register_ready        => register_ready(15+4*i+j),
            o_register_status       => register_status(2*(15+4*i+j)+1 downto 2*(15+4*i+j)),
            o_register_read_data    => register_read_data(32*(15+4*i+j)+31 downto 32*(15+4*i+j)),
            o_register_value        => register_value(32*(15+4*i+j)+0+31 downto 32*(15+4*i+j)+0),
            i_indirect_match        => indirect_match,
            o_bit_field_valid       => bit_field_valid,
            o_bit_field_read_mask   => bit_field_read_mask,
            o_bit_field_write_mask  => bit_field_write_mask,
            o_bit_field_write_data  => bit_field_write_data,
            i_bit_field_read_data   => bit_field_read_data,
            i_bit_field_value       => bit_field_value
          );
      CODE

      expect(registers[8]).to generate_code(:register, :top_down, <<~"CODE")
        \\g_tie_off\\: for \\__i\\ in 0 to 31 generate
          g: if (bit_slice(x"00000001", \\__i\\) = '0') generate
            bit_field_read_data(\\__i\\) <= '0';
            bit_field_value(\\__i\\) <= '0';
          end generate;
        end generate;
        indirect_match(0) <= '1' when unsigned(register_value(0 downto 0)) = 0 else '0';
        u_register: entity #{library_name}.rggen_indirect_register
          generic map (
            READABLE              => true,
            WRITABLE              => false,
            ADDRESS_WIDTH         => 8,
            OFFSET_ADDRESS        => x"20",
            BUS_WIDTH             => 32,
            DATA_WIDTH            => 32,
            INDIRECT_MATCH_WIDTH  => 1
          )
          port map (
            i_clk                   => i_clk,
            i_rst_n                 => i_rst_n,
            i_register_valid        => register_valid,
            i_register_access       => register_access,
            i_register_address      => register_address,
            i_register_write_data   => register_write_data,
            i_register_strobe       => register_strobe,
            o_register_active       => register_active(23),
            o_register_ready        => register_ready(23),
            o_register_status       => register_status(47 downto 46),
            o_register_read_data    => register_read_data(767 downto 736),
            o_register_value        => register_value(767 downto 736),
            i_indirect_match        => indirect_match,
            o_bit_field_valid       => bit_field_valid,
            o_bit_field_read_mask   => bit_field_read_mask,
            o_bit_field_write_mask  => bit_field_write_mask,
            o_bit_field_write_data  => bit_field_write_data,
            i_bit_field_read_data   => bit_field_read_data,
            i_bit_field_value       => bit_field_value
          );
      CODE

      expect(registers[9]).to generate_code(:register, :top_down, <<~"CODE")
        \\g_tie_off\\: for \\__i\\ in 0 to 31 generate
          g: if (bit_slice(x"00000001", \\__i\\) = '0') generate
            bit_field_read_data(\\__i\\) <= '0';
            bit_field_value(\\__i\\) <= '0';
          end generate;
        end generate;
        indirect_match(0) <= '1' when unsigned(register_value(0 downto 0)) = 0 else '0';
        u_register: entity #{library_name}.rggen_indirect_register
          generic map (
            READABLE              => false,
            WRITABLE              => true,
            ADDRESS_WIDTH         => 8,
            OFFSET_ADDRESS        => x"24",
            BUS_WIDTH             => 32,
            DATA_WIDTH            => 32,
            INDIRECT_MATCH_WIDTH  => 1
          )
          port map (
            i_clk                   => i_clk,
            i_rst_n                 => i_rst_n,
            i_register_valid        => register_valid,
            i_register_access       => register_access,
            i_register_address      => register_address,
            i_register_write_data   => register_write_data,
            i_register_strobe       => register_strobe,
            o_register_active       => register_active(24),
            o_register_ready        => register_ready(24),
            o_register_status       => register_status(49 downto 48),
            o_register_read_data    => register_read_data(799 downto 768),
            o_register_value        => register_value(799 downto 768),
            i_indirect_match        => indirect_match,
            o_bit_field_valid       => bit_field_valid,
            o_bit_field_read_mask   => bit_field_read_mask,
            o_bit_field_write_mask  => bit_field_write_mask,
            o_bit_field_write_data  => bit_field_write_data,
            i_bit_field_read_data   => bit_field_read_data,
            i_bit_field_value       => bit_field_value
          );
      CODE

      expect(registers[10]).to generate_code(:register, :top_down, <<~"CODE")
        \\g_tie_off\\: for \\__i\\ in 0 to 31 generate
          g: if (bit_slice(x"00000001", \\__i\\) = '0') generate
            bit_field_read_data(\\__i\\) <= '0';
            bit_field_value(\\__i\\) <= '0';
          end generate;
        end generate;
        indirect_match(0) <= '1' when unsigned(register_value(33 downto 32)) = i else '0';
        indirect_match(1) <= '1' when unsigned(register_value(65 downto 64)) = 0 else '0';
        u_register: entity #{library_name}.rggen_indirect_register
          generic map (
            READABLE              => true,
            WRITABLE              => true,
            ADDRESS_WIDTH         => 8,
            OFFSET_ADDRESS        => x"28",
            BUS_WIDTH             => 32,
            DATA_WIDTH            => 32,
            INDIRECT_MATCH_WIDTH  => 2
          )
          port map (
            i_clk                   => i_clk,
            i_rst_n                 => i_rst_n,
            i_register_valid        => register_valid,
            i_register_access       => register_access,
            i_register_address      => register_address,
            i_register_write_data   => register_write_data,
            i_register_strobe       => register_strobe,
            o_register_active       => register_active(25+i),
            o_register_ready        => register_ready(25+i),
            o_register_status       => register_status(2*(25+i)+1 downto 2*(25+i)),
            o_register_read_data    => register_read_data(32*(25+i)+31 downto 32*(25+i)),
            o_register_value        => register_value(32*(25+i)+0+31 downto 32*(25+i)+0),
            i_indirect_match        => indirect_match,
            o_bit_field_valid       => bit_field_valid,
            o_bit_field_read_mask   => bit_field_read_mask,
            o_bit_field_write_mask  => bit_field_write_mask,
            o_bit_field_write_data  => bit_field_write_data,
            i_bit_field_read_data   => bit_field_read_data,
            i_bit_field_value       => bit_field_value
          );
      CODE

      expect(registers[11]).to generate_code(:register, :top_down, <<~"CODE")
        \\g_tie_off\\: for \\__i\\ in 0 to 31 generate
          g: if (bit_slice(x"00000001", \\__i\\) = '0') generate
            bit_field_read_data(\\__i\\) <= '0';
            bit_field_value(\\__i\\) <= '0';
          end generate;
        end generate;
        indirect_match(0) <= '1' when unsigned(register_value(96 downto 96)) = 0 else '0';
        indirect_match(1) <= '1' when unsigned(register_value(105 downto 104)) = i else '0';
        indirect_match(2) <= '1' when unsigned(register_value(115 downto 112)) = j else '0';
        u_register: entity #{library_name}.rggen_indirect_register
          generic map (
            READABLE              => true,
            WRITABLE              => true,
            ADDRESS_WIDTH         => 8,
            OFFSET_ADDRESS        => x"2c",
            BUS_WIDTH             => 32,
            DATA_WIDTH            => 32,
            INDIRECT_MATCH_WIDTH  => 3
          )
          port map (
            i_clk                   => i_clk,
            i_rst_n                 => i_rst_n,
            i_register_valid        => register_valid,
            i_register_access       => register_access,
            i_register_address      => register_address,
            i_register_write_data   => register_write_data,
            i_register_strobe       => register_strobe,
            o_register_active       => register_active(27+4*i+j),
            o_register_ready        => register_ready(27+4*i+j),
            o_register_status       => register_status(2*(27+4*i+j)+1 downto 2*(27+4*i+j)),
            o_register_read_data    => register_read_data(32*(27+4*i+j)+31 downto 32*(27+4*i+j)),
            o_register_value        => register_value(32*(27+4*i+j)+0+31 downto 32*(27+4*i+j)+0),
            i_indirect_match        => indirect_match,
            o_bit_field_valid       => bit_field_valid,
            o_bit_field_read_mask   => bit_field_read_mask,
            o_bit_field_write_mask  => bit_field_write_mask,
            o_bit_field_write_data  => bit_field_write_data,
            i_bit_field_read_data   => bit_field_read_data,
            i_bit_field_value       => bit_field_value
          );
      CODE

      expect(registers[12]).to generate_code(:register, :top_down, <<~"CODE")
        \\g_tie_off\\: for \\__i\\ in 0 to 31 generate
          g: if (bit_slice(x"00000001", \\__i\\) = '0') generate
            bit_field_read_data(\\__i\\) <= '0';
            bit_field_value(\\__i\\) <= '0';
          end generate;
        end generate;
        indirect_match(0) <= '1' when unsigned(register_value(0 downto 0)) = 0 else '0';
        indirect_match(1) <= '1' when unsigned(register_value(9 downto 8)) = k else '0';
        indirect_match(2) <= '1' when unsigned(register_value(19 downto 16)) = l else '0';
        u_register: entity #{library_name}.rggen_indirect_register
          generic map (
            READABLE              => true,
            WRITABLE              => true,
            ADDRESS_WIDTH         => 8,
            OFFSET_ADDRESS        => x"30"+8*(2*i+j),
            BUS_WIDTH             => 32,
            DATA_WIDTH            => 32,
            INDIRECT_MATCH_WIDTH  => 3
          )
          port map (
            i_clk                   => i_clk,
            i_rst_n                 => i_rst_n,
            i_register_valid        => register_valid,
            i_register_access       => register_access,
            i_register_address      => register_address,
            i_register_write_data   => register_write_data,
            i_register_strobe       => register_strobe,
            o_register_active       => register_active(35+16*(2*i+j)+4*k+l),
            o_register_ready        => register_ready(35+16*(2*i+j)+4*k+l),
            o_register_status       => register_status(2*(35+16*(2*i+j)+4*k+l)+1 downto 2*(35+16*(2*i+j)+4*k+l)),
            o_register_read_data    => register_read_data(32*(35+16*(2*i+j)+4*k+l)+31 downto 32*(35+16*(2*i+j)+4*k+l)),
            o_register_value        => register_value(32*(35+16*(2*i+j)+4*k+l)+0+31 downto 32*(35+16*(2*i+j)+4*k+l)+0),
            i_indirect_match        => indirect_match,
            o_bit_field_valid       => bit_field_valid,
            o_bit_field_read_mask   => bit_field_read_mask,
            o_bit_field_write_mask  => bit_field_write_mask,
            o_bit_field_write_data  => bit_field_write_data,
            i_bit_field_read_data   => bit_field_read_data,
            i_bit_field_value       => bit_field_value
          );
      CODE

      expect(registers[13]).to generate_code(:register, :top_down, <<~"CODE")
        \\g_tie_off\\: for \\__i\\ in 0 to 31 generate
          g: if (bit_slice(x"00000001", \\__i\\) = '0') generate
            bit_field_read_data(\\__i\\) <= '0';
            bit_field_value(\\__i\\) <= '0';
          end generate;
        end generate;
        indirect_match(0) <= '1' when unsigned(register_value(96 downto 96)) = 0 else '0';
        indirect_match(1) <= '1' when unsigned(register_value(105 downto 104)) = k else '0';
        indirect_match(2) <= '1' when unsigned(register_value(115 downto 112)) = l else '0';
        u_register: entity #{library_name}.rggen_indirect_register
          generic map (
            READABLE              => true,
            WRITABLE              => true,
            ADDRESS_WIDTH         => 8,
            OFFSET_ADDRESS        => x"30"+8*(2*i+j)+x"04",
            BUS_WIDTH             => 32,
            DATA_WIDTH            => 32,
            INDIRECT_MATCH_WIDTH  => 3
          )
          port map (
            i_clk                   => i_clk,
            i_rst_n                 => i_rst_n,
            i_register_valid        => register_valid,
            i_register_access       => register_access,
            i_register_address      => register_address,
            i_register_write_data   => register_write_data,
            i_register_strobe       => register_strobe,
            o_register_active       => register_active(35+16*(2*i+j)+8+4*k+l),
            o_register_ready        => register_ready(35+16*(2*i+j)+8+4*k+l),
            o_register_status       => register_status(2*(35+16*(2*i+j)+8+4*k+l)+1 downto 2*(35+16*(2*i+j)+8+4*k+l)),
            o_register_read_data    => register_read_data(32*(35+16*(2*i+j)+8+4*k+l)+31 downto 32*(35+16*(2*i+j)+8+4*k+l)),
            o_register_value        => register_value(32*(35+16*(2*i+j)+8+4*k+l)+0+31 downto 32*(35+16*(2*i+j)+8+4*k+l)+0),
            i_indirect_match        => indirect_match,
            o_bit_field_valid       => bit_field_valid,
            o_bit_field_read_mask   => bit_field_read_mask,
            o_bit_field_write_mask  => bit_field_write_mask,
            o_bit_field_write_data  => bit_field_write_data,
            i_bit_field_read_data   => bit_field_read_data,
            i_bit_field_value       => bit_field_value
          );
      CODE
    end
  end
end
