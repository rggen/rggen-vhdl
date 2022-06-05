# frozen_string_literal: true

RSpec.describe 'register/type/default' do
  include_context 'clean-up builder'
  include_context 'vhdl common'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width])
    RgGen.enable(:register_block, :byte_size)
    RgGen.enable(:register_file, [:name, :offset_address, :size])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :type, :initial_value, :reference])
    RgGen.enable(:bit_field, :type, [:rw, :ro, :wo])
    RgGen.enable(:register_block, :vhdl_top)
    RgGen.enable(:register_file, :vhdl_top)
    RgGen.enable(:register, :vhdl_top)
    RgGen.enable(:bit_field, :vhdl_top)
  end

  describe '#generate_code' do
    let(:registers) do
      vhdl = create_vhdl do
        byte_size 512

        register do
          name 'register_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end

        register do
          name 'register_1'
          offset_address 0x10
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end

        register do
          name 'register_2'
          offset_address 0x20
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end

        register do
          name 'register_3'
          offset_address 0x30
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 32; type :rw; initial_value 0 }
        end

        register do
          name 'register_4'
          offset_address 0x40
          bit_field { name 'bit_field_0'; bit_assignment lsb: 4, width: 4, sequence_size: 4, step: 8; type :rw; initial_value 0 }
        end

        register do
          name 'register_5'
          offset_address 0x50
          bit_field { name 'bit_field_0'; bit_assignment lsb: 32; type :rw; initial_value 0 }
        end

        register do
          name 'register_6'
          offset_address 0x60
          bit_field { name 'bit_field_0'; bit_assignment lsb: 4, width: 4, sequence_size: 8, step: 8; type :rw; initial_value 0 }
        end

        register do
          name 'register_7'
          offset_address 0x70
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :ro }
        end

        register do
          name 'register_8'
          offset_address 0x80
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :wo; initial_value 0 }
        end

        register_file do
          name 'register_file_9'
          offset_address 0x90
          size [2, 2]
          register_file do
            name 'register_file_0'
            offset_address 0x10
            register do
              name 'register_0'
              offset_address 0x00
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4; type :rw; initial_value 0 }
            end
          end
        end
      end
      vhdl.registers
    end

    it 'rggen_default_registerをインスタンスするコードを出力する' do
      expect(registers[0]).to generate_code(:register, :top_down, <<~'CODE')
        \g_tie_off\: for \__i\ in 0 to 31 generate
          g: if (bit_slice(x"00000001", \__i\) = '0') generate
            bit_field_read_data(\__i\) <= '0';
            bit_field_value(\__i\) <= '0';
          end generate;
        end generate;
        u_register: entity work.rggen_default_register
          generic map (
            READABLE        => true,
            WRITABLE        => true,
            ADDRESS_WIDTH   => 9,
            OFFSET_ADDRESS  => x"000",
            BUS_WIDTH       => 32,
            DATA_WIDTH      => 32,
            REGISTER_INDEX  => 0
          )
          port map (
            i_clk                   => i_clk,
            i_rst_n                 => i_rst_n,
            i_register_valid        => register_valid,
            i_register_access       => register_access,
            i_register_address      => register_address,
            i_register_write_data   => register_write_data,
            i_register_strobe       => register_strobe,
            o_register_active       => register_active(0),
            o_register_ready        => register_ready(0),
            o_register_status       => register_status(1 downto 0),
            o_register_read_data    => register_read_data(31 downto 0),
            o_register_value        => register_value(31 downto 0),
            o_bit_field_valid       => bit_field_valid,
            o_bit_field_read_mask   => bit_field_read_mask,
            o_bit_field_write_mask  => bit_field_write_mask,
            o_bit_field_write_data  => bit_field_write_data,
            i_bit_field_read_data   => bit_field_read_data,
            i_bit_field_value       => bit_field_value
          );
      CODE

      expect(registers[1]).to generate_code(:register, :top_down, <<~'CODE')
        \g_tie_off\: for \__i\ in 0 to 31 generate
          g: if (bit_slice(x"00000001", \__i\) = '0') generate
            bit_field_read_data(\__i\) <= '0';
            bit_field_value(\__i\) <= '0';
          end generate;
        end generate;
        u_register: entity work.rggen_default_register
          generic map (
            READABLE        => true,
            WRITABLE        => true,
            ADDRESS_WIDTH   => 9,
            OFFSET_ADDRESS  => x"010",
            BUS_WIDTH       => 32,
            DATA_WIDTH      => 32,
            REGISTER_INDEX  => i
          )
          port map (
            i_clk                   => i_clk,
            i_rst_n                 => i_rst_n,
            i_register_valid        => register_valid,
            i_register_access       => register_access,
            i_register_address      => register_address,
            i_register_write_data   => register_write_data,
            i_register_strobe       => register_strobe,
            o_register_active       => register_active(1+i),
            o_register_ready        => register_ready(1+i),
            o_register_status       => register_status(2*(1+i)+1 downto 2*(1+i)),
            o_register_read_data    => register_read_data(32*(1+i)+31 downto 32*(1+i)),
            o_register_value        => register_value(64*(1+i)+0+31 downto 64*(1+i)+0),
            o_bit_field_valid       => bit_field_valid,
            o_bit_field_read_mask   => bit_field_read_mask,
            o_bit_field_write_mask  => bit_field_write_mask,
            o_bit_field_write_data  => bit_field_write_data,
            i_bit_field_read_data   => bit_field_read_data,
            i_bit_field_value       => bit_field_value
          );
      CODE

      expect(registers[2]).to generate_code(:register, :top_down, <<~'CODE')
        \g_tie_off\: for \__i\ in 0 to 31 generate
          g: if (bit_slice(x"00000001", \__i\) = '0') generate
            bit_field_read_data(\__i\) <= '0';
            bit_field_value(\__i\) <= '0';
          end generate;
        end generate;
        u_register: entity work.rggen_default_register
          generic map (
            READABLE        => true,
            WRITABLE        => true,
            ADDRESS_WIDTH   => 9,
            OFFSET_ADDRESS  => x"020",
            BUS_WIDTH       => 32,
            DATA_WIDTH      => 32,
            REGISTER_INDEX  => 2*i+j
          )
          port map (
            i_clk                   => i_clk,
            i_rst_n                 => i_rst_n,
            i_register_valid        => register_valid,
            i_register_access       => register_access,
            i_register_address      => register_address,
            i_register_write_data   => register_write_data,
            i_register_strobe       => register_strobe,
            o_register_active       => register_active(5+2*i+j),
            o_register_ready        => register_ready(5+2*i+j),
            o_register_status       => register_status(2*(5+2*i+j)+1 downto 2*(5+2*i+j)),
            o_register_read_data    => register_read_data(32*(5+2*i+j)+31 downto 32*(5+2*i+j)),
            o_register_value        => register_value(64*(5+2*i+j)+0+31 downto 64*(5+2*i+j)+0),
            o_bit_field_valid       => bit_field_valid,
            o_bit_field_read_mask   => bit_field_read_mask,
            o_bit_field_write_mask  => bit_field_write_mask,
            o_bit_field_write_data  => bit_field_write_data,
            i_bit_field_read_data   => bit_field_read_data,
            i_bit_field_value       => bit_field_value
          );
      CODE

      expect(registers[3]).to generate_code(:register, :top_down, <<~'CODE')
        \g_tie_off\: for \__i\ in 0 to 31 generate
          g: if (bit_slice(x"ffffffff", \__i\) = '0') generate
            bit_field_read_data(\__i\) <= '0';
            bit_field_value(\__i\) <= '0';
          end generate;
        end generate;
        u_register: entity work.rggen_default_register
          generic map (
            READABLE        => true,
            WRITABLE        => true,
            ADDRESS_WIDTH   => 9,
            OFFSET_ADDRESS  => x"030",
            BUS_WIDTH       => 32,
            DATA_WIDTH      => 32,
            REGISTER_INDEX  => 0
          )
          port map (
            i_clk                   => i_clk,
            i_rst_n                 => i_rst_n,
            i_register_valid        => register_valid,
            i_register_access       => register_access,
            i_register_address      => register_address,
            i_register_write_data   => register_write_data,
            i_register_strobe       => register_strobe,
            o_register_active       => register_active(9),
            o_register_ready        => register_ready(9),
            o_register_status       => register_status(19 downto 18),
            o_register_read_data    => register_read_data(319 downto 288),
            o_register_value        => register_value(607 downto 576),
            o_bit_field_valid       => bit_field_valid,
            o_bit_field_read_mask   => bit_field_read_mask,
            o_bit_field_write_mask  => bit_field_write_mask,
            o_bit_field_write_data  => bit_field_write_data,
            i_bit_field_read_data   => bit_field_read_data,
            i_bit_field_value       => bit_field_value
          );
      CODE

      expect(registers[4]).to generate_code(:register, :top_down, <<~'CODE')
        \g_tie_off\: for \__i\ in 0 to 31 generate
          g: if (bit_slice(x"f0f0f0f0", \__i\) = '0') generate
            bit_field_read_data(\__i\) <= '0';
            bit_field_value(\__i\) <= '0';
          end generate;
        end generate;
        u_register: entity work.rggen_default_register
          generic map (
            READABLE        => true,
            WRITABLE        => true,
            ADDRESS_WIDTH   => 9,
            OFFSET_ADDRESS  => x"040",
            BUS_WIDTH       => 32,
            DATA_WIDTH      => 32,
            REGISTER_INDEX  => 0
          )
          port map (
            i_clk                   => i_clk,
            i_rst_n                 => i_rst_n,
            i_register_valid        => register_valid,
            i_register_access       => register_access,
            i_register_address      => register_address,
            i_register_write_data   => register_write_data,
            i_register_strobe       => register_strobe,
            o_register_active       => register_active(10),
            o_register_ready        => register_ready(10),
            o_register_status       => register_status(21 downto 20),
            o_register_read_data    => register_read_data(351 downto 320),
            o_register_value        => register_value(671 downto 640),
            o_bit_field_valid       => bit_field_valid,
            o_bit_field_read_mask   => bit_field_read_mask,
            o_bit_field_write_mask  => bit_field_write_mask,
            o_bit_field_write_data  => bit_field_write_data,
            i_bit_field_read_data   => bit_field_read_data,
            i_bit_field_value       => bit_field_value
          );
      CODE

      expect(registers[5]).to generate_code(:register, :top_down, <<~'CODE')
        \g_tie_off\: for \__i\ in 0 to 63 generate
          g: if (bit_slice(x"0000000100000000", \__i\) = '0') generate
            bit_field_read_data(\__i\) <= '0';
            bit_field_value(\__i\) <= '0';
          end generate;
        end generate;
        u_register: entity work.rggen_default_register
          generic map (
            READABLE        => true,
            WRITABLE        => true,
            ADDRESS_WIDTH   => 9,
            OFFSET_ADDRESS  => x"050",
            BUS_WIDTH       => 32,
            DATA_WIDTH      => 64,
            REGISTER_INDEX  => 0
          )
          port map (
            i_clk                   => i_clk,
            i_rst_n                 => i_rst_n,
            i_register_valid        => register_valid,
            i_register_access       => register_access,
            i_register_address      => register_address,
            i_register_write_data   => register_write_data,
            i_register_strobe       => register_strobe,
            o_register_active       => register_active(11),
            o_register_ready        => register_ready(11),
            o_register_status       => register_status(23 downto 22),
            o_register_read_data    => register_read_data(383 downto 352),
            o_register_value        => register_value(767 downto 704),
            o_bit_field_valid       => bit_field_valid,
            o_bit_field_read_mask   => bit_field_read_mask,
            o_bit_field_write_mask  => bit_field_write_mask,
            o_bit_field_write_data  => bit_field_write_data,
            i_bit_field_read_data   => bit_field_read_data,
            i_bit_field_value       => bit_field_value
          );
      CODE

      expect(registers[6]).to generate_code(:register, :top_down, <<~'CODE')
        \g_tie_off\: for \__i\ in 0 to 63 generate
          g: if (bit_slice(x"f0f0f0f0f0f0f0f0", \__i\) = '0') generate
            bit_field_read_data(\__i\) <= '0';
            bit_field_value(\__i\) <= '0';
          end generate;
        end generate;
        u_register: entity work.rggen_default_register
          generic map (
            READABLE        => true,
            WRITABLE        => true,
            ADDRESS_WIDTH   => 9,
            OFFSET_ADDRESS  => x"060",
            BUS_WIDTH       => 32,
            DATA_WIDTH      => 64,
            REGISTER_INDEX  => 0
          )
          port map (
            i_clk                   => i_clk,
            i_rst_n                 => i_rst_n,
            i_register_valid        => register_valid,
            i_register_access       => register_access,
            i_register_address      => register_address,
            i_register_write_data   => register_write_data,
            i_register_strobe       => register_strobe,
            o_register_active       => register_active(12),
            o_register_ready        => register_ready(12),
            o_register_status       => register_status(25 downto 24),
            o_register_read_data    => register_read_data(415 downto 384),
            o_register_value        => register_value(831 downto 768),
            o_bit_field_valid       => bit_field_valid,
            o_bit_field_read_mask   => bit_field_read_mask,
            o_bit_field_write_mask  => bit_field_write_mask,
            o_bit_field_write_data  => bit_field_write_data,
            i_bit_field_read_data   => bit_field_read_data,
            i_bit_field_value       => bit_field_value
          );
      CODE

      expect(registers[7]).to generate_code(:register, :top_down, <<~'CODE')
        \g_tie_off\: for \__i\ in 0 to 31 generate
          g: if (bit_slice(x"00000001", \__i\) = '0') generate
            bit_field_read_data(\__i\) <= '0';
            bit_field_value(\__i\) <= '0';
          end generate;
        end generate;
        u_register: entity work.rggen_default_register
          generic map (
            READABLE        => true,
            WRITABLE        => false,
            ADDRESS_WIDTH   => 9,
            OFFSET_ADDRESS  => x"070",
            BUS_WIDTH       => 32,
            DATA_WIDTH      => 32,
            REGISTER_INDEX  => 0
          )
          port map (
            i_clk                   => i_clk,
            i_rst_n                 => i_rst_n,
            i_register_valid        => register_valid,
            i_register_access       => register_access,
            i_register_address      => register_address,
            i_register_write_data   => register_write_data,
            i_register_strobe       => register_strobe,
            o_register_active       => register_active(13),
            o_register_ready        => register_ready(13),
            o_register_status       => register_status(27 downto 26),
            o_register_read_data    => register_read_data(447 downto 416),
            o_register_value        => register_value(863 downto 832),
            o_bit_field_valid       => bit_field_valid,
            o_bit_field_read_mask   => bit_field_read_mask,
            o_bit_field_write_mask  => bit_field_write_mask,
            o_bit_field_write_data  => bit_field_write_data,
            i_bit_field_read_data   => bit_field_read_data,
            i_bit_field_value       => bit_field_value
          );
      CODE

      expect(registers[8]).to generate_code(:register, :top_down, <<~'CODE')
        \g_tie_off\: for \__i\ in 0 to 31 generate
          g: if (bit_slice(x"00000001", \__i\) = '0') generate
            bit_field_read_data(\__i\) <= '0';
            bit_field_value(\__i\) <= '0';
          end generate;
        end generate;
        u_register: entity work.rggen_default_register
          generic map (
            READABLE        => false,
            WRITABLE        => true,
            ADDRESS_WIDTH   => 9,
            OFFSET_ADDRESS  => x"080",
            BUS_WIDTH       => 32,
            DATA_WIDTH      => 32,
            REGISTER_INDEX  => 0
          )
          port map (
            i_clk                   => i_clk,
            i_rst_n                 => i_rst_n,
            i_register_valid        => register_valid,
            i_register_access       => register_access,
            i_register_address      => register_address,
            i_register_write_data   => register_write_data,
            i_register_strobe       => register_strobe,
            o_register_active       => register_active(14),
            o_register_ready        => register_ready(14),
            o_register_status       => register_status(29 downto 28),
            o_register_read_data    => register_read_data(479 downto 448),
            o_register_value        => register_value(927 downto 896),
            o_bit_field_valid       => bit_field_valid,
            o_bit_field_read_mask   => bit_field_read_mask,
            o_bit_field_write_mask  => bit_field_write_mask,
            o_bit_field_write_data  => bit_field_write_data,
            i_bit_field_read_data   => bit_field_read_data,
            i_bit_field_value       => bit_field_value
          );
      CODE

      expect(registers[9]).to generate_code(:register, :top_down, <<~'CODE')
        \g_tie_off\: for \__i\ in 0 to 31 generate
          g: if (bit_slice(x"0000ffff", \__i\) = '0') generate
            bit_field_read_data(\__i\) <= '0';
            bit_field_value(\__i\) <= '0';
          end generate;
        end generate;
        u_register: entity work.rggen_default_register
          generic map (
            READABLE        => true,
            WRITABLE        => true,
            ADDRESS_WIDTH   => 9,
            OFFSET_ADDRESS  => x"090"+32*(2*i+j)+x"010",
            BUS_WIDTH       => 32,
            DATA_WIDTH      => 32,
            REGISTER_INDEX  => 2*k+l
          )
          port map (
            i_clk                   => i_clk,
            i_rst_n                 => i_rst_n,
            i_register_valid        => register_valid,
            i_register_access       => register_access,
            i_register_address      => register_address,
            i_register_write_data   => register_write_data,
            i_register_strobe       => register_strobe,
            o_register_active       => register_active(15+4*(2*i+j)+2*k+l),
            o_register_ready        => register_ready(15+4*(2*i+j)+2*k+l),
            o_register_status       => register_status(2*(15+4*(2*i+j)+2*k+l)+1 downto 2*(15+4*(2*i+j)+2*k+l)),
            o_register_read_data    => register_read_data(32*(15+4*(2*i+j)+2*k+l)+31 downto 32*(15+4*(2*i+j)+2*k+l)),
            o_register_value        => register_value(64*(15+4*(2*i+j)+2*k+l)+0+31 downto 64*(15+4*(2*i+j)+2*k+l)+0),
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
