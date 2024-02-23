# frozen_string_literal: true

RSpec.describe 'register_file/vhdl_top' do
  include_context 'vhdl common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :enable_wide_register, :library_name])
    RgGen.enable(:register_block, [:name, :byte_size])
    RgGen.enable(:register_file, [:name, :offset_address, :size])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:register, :type, [:external, :indirect])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :type, :initial_value, :reference])
    RgGen.enable(:bit_field, :type, :rw)
    RgGen.enable(:register_block, :vhdl_top)
    RgGen.enable(:register_file, :vhdl_top)
    RgGen.enable(:register, :vhdl_top)
    RgGen.enable(:bit_field, :vhdl_top)
  end

  def create_register_files(&body)
    create_vhdl(&body).register_blocks[0].register_files(false)
  end

  describe '#generate_code' do
    it 'レジスタファイル階層のコードを出力する' do
      register_files = create_register_files do
        name 'block_0'
        byte_size 512

        register_file do
          name 'register_file_0'
          offset_address 0x00
          register do
            name 'register_0'
            offset_address 0x00
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end
          register do
            name 'register_1'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end
        end

        register_file do
          name 'register_file_1'
          offset_address 0x10

          register_file do
            name 'register_file_0'
            offset_address 0x00
            register do
              name 'register_0'
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
            end
          end

          register do
            name 'register_1'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end
        end

        register_file do
          name 'register_file_2'
          offset_address 0x20
          size [2, 2]

          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
            end
          end

          register do
            name 'register_1'
            size [2, 2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end
        end

        register_file do
          name 'register_file_3'
          offset_address 0xA0
          size [2, step: 64]

          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
            end
          end

          register do
            name 'register_1'
            size [2, step: 8]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end
        end
      end

      expect(register_files[0]).to generate_code(:register_file, :top_down, 0, <<~'CODE')
        g_register_file_0: block
        begin
          g_register_0: block
            signal bit_field_valid: std_logic;
            signal bit_field_read_mask: std_logic_vector(31 downto 0);
            signal bit_field_write_mask: std_logic_vector(31 downto 0);
            signal bit_field_write_data: std_logic_vector(31 downto 0);
            signal bit_field_read_data: std_logic_vector(31 downto 0);
            signal bit_field_value: std_logic_vector(31 downto 0);
          begin
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
                DATA_WIDTH      => 32
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
            g_bit_field_0: block
            begin
              u_bit_field: entity work.rggen_bit_field
                generic map (
                  WIDTH           => 1,
                  INITIAL_VALUE   => slice(x"0", 1, 0),
                  SW_WRITE_ONCE   => false,
                  TRIGGER         => false
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
                  i_hw_write_enable => "0",
                  i_hw_write_data   => (others => '0'),
                  i_hw_set          => (others => '0'),
                  i_hw_clear        => (others => '0'),
                  i_value           => (others => '0'),
                  i_mask            => (others => '1'),
                  o_value           => o_register_file_0_register_0_bit_field_0,
                  o_value_unmasked  => open
                );
            end block;
          end block;
          g_register_1: block
            signal bit_field_valid: std_logic;
            signal bit_field_read_mask: std_logic_vector(31 downto 0);
            signal bit_field_write_mask: std_logic_vector(31 downto 0);
            signal bit_field_write_data: std_logic_vector(31 downto 0);
            signal bit_field_read_data: std_logic_vector(31 downto 0);
            signal bit_field_value: std_logic_vector(31 downto 0);
          begin
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
                OFFSET_ADDRESS  => x"004",
                BUS_WIDTH       => 32,
                DATA_WIDTH      => 32
              )
              port map (
                i_clk                   => i_clk,
                i_rst_n                 => i_rst_n,
                i_register_valid        => register_valid,
                i_register_access       => register_access,
                i_register_address      => register_address,
                i_register_write_data   => register_write_data,
                i_register_strobe       => register_strobe,
                o_register_active       => register_active(1),
                o_register_ready        => register_ready(1),
                o_register_status       => register_status(3 downto 2),
                o_register_read_data    => register_read_data(63 downto 32),
                o_register_value        => register_value(63 downto 32),
                o_bit_field_valid       => bit_field_valid,
                o_bit_field_read_mask   => bit_field_read_mask,
                o_bit_field_write_mask  => bit_field_write_mask,
                o_bit_field_write_data  => bit_field_write_data,
                i_bit_field_read_data   => bit_field_read_data,
                i_bit_field_value       => bit_field_value
              );
            g_bit_field_0: block
            begin
              u_bit_field: entity work.rggen_bit_field
                generic map (
                  WIDTH           => 1,
                  INITIAL_VALUE   => slice(x"0", 1, 0),
                  SW_WRITE_ONCE   => false,
                  TRIGGER         => false
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
                  i_hw_write_enable => "0",
                  i_hw_write_data   => (others => '0'),
                  i_hw_set          => (others => '0'),
                  i_hw_clear        => (others => '0'),
                  i_value           => (others => '0'),
                  i_mask            => (others => '1'),
                  o_value           => o_register_file_0_register_1_bit_field_0,
                  o_value_unmasked  => open
                );
            end block;
          end block;
        end block;
      CODE

      expect(register_files[1]).to generate_code(:register_file, :top_down, 0, <<~'CODE')
        g_register_file_1: block
        begin
          g_register_file_0: block
          begin
            g_register_0: block
              signal bit_field_valid: std_logic;
              signal bit_field_read_mask: std_logic_vector(31 downto 0);
              signal bit_field_write_mask: std_logic_vector(31 downto 0);
              signal bit_field_write_data: std_logic_vector(31 downto 0);
              signal bit_field_read_data: std_logic_vector(31 downto 0);
              signal bit_field_value: std_logic_vector(31 downto 0);
            begin
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
                  DATA_WIDTH      => 32
                )
                port map (
                  i_clk                   => i_clk,
                  i_rst_n                 => i_rst_n,
                  i_register_valid        => register_valid,
                  i_register_access       => register_access,
                  i_register_address      => register_address,
                  i_register_write_data   => register_write_data,
                  i_register_strobe       => register_strobe,
                  o_register_active       => register_active(2),
                  o_register_ready        => register_ready(2),
                  o_register_status       => register_status(5 downto 4),
                  o_register_read_data    => register_read_data(95 downto 64),
                  o_register_value        => register_value(95 downto 64),
                  o_bit_field_valid       => bit_field_valid,
                  o_bit_field_read_mask   => bit_field_read_mask,
                  o_bit_field_write_mask  => bit_field_write_mask,
                  o_bit_field_write_data  => bit_field_write_data,
                  i_bit_field_read_data   => bit_field_read_data,
                  i_bit_field_value       => bit_field_value
                );
              g_bit_field_0: block
              begin
                u_bit_field: entity work.rggen_bit_field
                  generic map (
                    WIDTH           => 1,
                    INITIAL_VALUE   => slice(x"0", 1, 0),
                    SW_WRITE_ONCE   => false,
                    TRIGGER         => false
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
                    i_hw_write_enable => "0",
                    i_hw_write_data   => (others => '0'),
                    i_hw_set          => (others => '0'),
                    i_hw_clear        => (others => '0'),
                    i_value           => (others => '0'),
                    i_mask            => (others => '1'),
                    o_value           => o_register_file_1_register_file_0_register_0_bit_field_0,
                    o_value_unmasked  => open
                  );
              end block;
            end block;
          end block;
          g_register_1: block
            signal bit_field_valid: std_logic;
            signal bit_field_read_mask: std_logic_vector(31 downto 0);
            signal bit_field_write_mask: std_logic_vector(31 downto 0);
            signal bit_field_write_data: std_logic_vector(31 downto 0);
            signal bit_field_read_data: std_logic_vector(31 downto 0);
            signal bit_field_value: std_logic_vector(31 downto 0);
          begin
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
                OFFSET_ADDRESS  => x"014",
                BUS_WIDTH       => 32,
                DATA_WIDTH      => 32
              )
              port map (
                i_clk                   => i_clk,
                i_rst_n                 => i_rst_n,
                i_register_valid        => register_valid,
                i_register_access       => register_access,
                i_register_address      => register_address,
                i_register_write_data   => register_write_data,
                i_register_strobe       => register_strobe,
                o_register_active       => register_active(3),
                o_register_ready        => register_ready(3),
                o_register_status       => register_status(7 downto 6),
                o_register_read_data    => register_read_data(127 downto 96),
                o_register_value        => register_value(127 downto 96),
                o_bit_field_valid       => bit_field_valid,
                o_bit_field_read_mask   => bit_field_read_mask,
                o_bit_field_write_mask  => bit_field_write_mask,
                o_bit_field_write_data  => bit_field_write_data,
                i_bit_field_read_data   => bit_field_read_data,
                i_bit_field_value       => bit_field_value
              );
            g_bit_field_0: block
            begin
              u_bit_field: entity work.rggen_bit_field
                generic map (
                  WIDTH           => 1,
                  INITIAL_VALUE   => slice(x"0", 1, 0),
                  SW_WRITE_ONCE   => false,
                  TRIGGER         => false
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
                  i_hw_write_enable => "0",
                  i_hw_write_data   => (others => '0'),
                  i_hw_set          => (others => '0'),
                  i_hw_clear        => (others => '0'),
                  i_value           => (others => '0'),
                  i_mask            => (others => '1'),
                  o_value           => o_register_file_1_register_1_bit_field_0,
                  o_value_unmasked  => open
                );
            end block;
          end block;
        end block;
      CODE

      expect(register_files[2]).to generate_code(:register_file, :top_down, 0, <<~'CODE')
        g_register_file_2: block
        begin
          g: for i in 0 to 1 generate
          begin
            g: for j in 0 to 1 generate
            begin
              g_register_file_0: block
              begin
                g_register_0: block
                begin
                  g: for k in 0 to 1 generate
                  begin
                    g: for l in 0 to 1 generate
                      signal bit_field_valid: std_logic;
                      signal bit_field_read_mask: std_logic_vector(31 downto 0);
                      signal bit_field_write_mask: std_logic_vector(31 downto 0);
                      signal bit_field_write_data: std_logic_vector(31 downto 0);
                      signal bit_field_read_data: std_logic_vector(31 downto 0);
                      signal bit_field_value: std_logic_vector(31 downto 0);
                    begin
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
                          OFFSET_ADDRESS  => x"020"+32*(2*i+j)+4*(2*k+l),
                          BUS_WIDTH       => 32,
                          DATA_WIDTH      => 32
                        )
                        port map (
                          i_clk                   => i_clk,
                          i_rst_n                 => i_rst_n,
                          i_register_valid        => register_valid,
                          i_register_access       => register_access,
                          i_register_address      => register_address,
                          i_register_write_data   => register_write_data,
                          i_register_strobe       => register_strobe,
                          o_register_active       => register_active(4+8*(2*i+j)+2*k+l),
                          o_register_ready        => register_ready(4+8*(2*i+j)+2*k+l),
                          o_register_status       => register_status(2*(4+8*(2*i+j)+2*k+l)+1 downto 2*(4+8*(2*i+j)+2*k+l)),
                          o_register_read_data    => register_read_data(32*(4+8*(2*i+j)+2*k+l)+31 downto 32*(4+8*(2*i+j)+2*k+l)),
                          o_register_value        => register_value(32*(4+8*(2*i+j)+2*k+l)+0+31 downto 32*(4+8*(2*i+j)+2*k+l)+0),
                          o_bit_field_valid       => bit_field_valid,
                          o_bit_field_read_mask   => bit_field_read_mask,
                          o_bit_field_write_mask  => bit_field_write_mask,
                          o_bit_field_write_data  => bit_field_write_data,
                          i_bit_field_read_data   => bit_field_read_data,
                          i_bit_field_value       => bit_field_value
                        );
                      g_bit_field_0: block
                      begin
                        u_bit_field: entity work.rggen_bit_field
                          generic map (
                            WIDTH           => 1,
                            INITIAL_VALUE   => slice(x"0", 1, 0),
                            SW_WRITE_ONCE   => false,
                            TRIGGER         => false
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
                            i_hw_write_enable => "0",
                            i_hw_write_data   => (others => '0'),
                            i_hw_set          => (others => '0'),
                            i_hw_clear        => (others => '0'),
                            i_value           => (others => '0'),
                            i_mask            => (others => '1'),
                            o_value           => o_register_file_2_register_file_0_register_0_bit_field_0(1*(8*i+4*j+2*k+l)+0 downto 1*(8*i+4*j+2*k+l)),
                            o_value_unmasked  => open
                          );
                      end block;
                    end generate;
                  end generate;
                end block;
              end block;
              g_register_1: block
              begin
                g: for k in 0 to 1 generate
                begin
                  g: for l in 0 to 1 generate
                    signal bit_field_valid: std_logic;
                    signal bit_field_read_mask: std_logic_vector(31 downto 0);
                    signal bit_field_write_mask: std_logic_vector(31 downto 0);
                    signal bit_field_write_data: std_logic_vector(31 downto 0);
                    signal bit_field_read_data: std_logic_vector(31 downto 0);
                    signal bit_field_value: std_logic_vector(31 downto 0);
                  begin
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
                        OFFSET_ADDRESS  => x"020"+32*(2*i+j)+x"010"+4*(2*k+l),
                        BUS_WIDTH       => 32,
                        DATA_WIDTH      => 32
                      )
                      port map (
                        i_clk                   => i_clk,
                        i_rst_n                 => i_rst_n,
                        i_register_valid        => register_valid,
                        i_register_access       => register_access,
                        i_register_address      => register_address,
                        i_register_write_data   => register_write_data,
                        i_register_strobe       => register_strobe,
                        o_register_active       => register_active(4+8*(2*i+j)+4+2*k+l),
                        o_register_ready        => register_ready(4+8*(2*i+j)+4+2*k+l),
                        o_register_status       => register_status(2*(4+8*(2*i+j)+4+2*k+l)+1 downto 2*(4+8*(2*i+j)+4+2*k+l)),
                        o_register_read_data    => register_read_data(32*(4+8*(2*i+j)+4+2*k+l)+31 downto 32*(4+8*(2*i+j)+4+2*k+l)),
                        o_register_value        => register_value(32*(4+8*(2*i+j)+4+2*k+l)+0+31 downto 32*(4+8*(2*i+j)+4+2*k+l)+0),
                        o_bit_field_valid       => bit_field_valid,
                        o_bit_field_read_mask   => bit_field_read_mask,
                        o_bit_field_write_mask  => bit_field_write_mask,
                        o_bit_field_write_data  => bit_field_write_data,
                        i_bit_field_read_data   => bit_field_read_data,
                        i_bit_field_value       => bit_field_value
                      );
                    g_bit_field_0: block
                    begin
                      u_bit_field: entity work.rggen_bit_field
                        generic map (
                          WIDTH           => 1,
                          INITIAL_VALUE   => slice(x"0", 1, 0),
                          SW_WRITE_ONCE   => false,
                          TRIGGER         => false
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
                          i_hw_write_enable => "0",
                          i_hw_write_data   => (others => '0'),
                          i_hw_set          => (others => '0'),
                          i_hw_clear        => (others => '0'),
                          i_value           => (others => '0'),
                          i_mask            => (others => '1'),
                          o_value           => o_register_file_2_register_1_bit_field_0(1*(8*i+4*j+2*k+l)+0 downto 1*(8*i+4*j+2*k+l)),
                          o_value_unmasked  => open
                        );
                    end block;
                  end generate;
                end generate;
              end block;
            end generate;
          end generate;
        end block;
      CODE

      expect(register_files[3]).to generate_code(:register_file, :top_down, 0, <<~'CODE')
        g_register_file_3: block
        begin
          g: for i in 0 to 1 generate
          begin
            g_register_file_0: block
            begin
              g_register_0: block
              begin
                g: for j in 0 to 1 generate
                begin
                  g: for k in 0 to 1 generate
                    signal bit_field_valid: std_logic;
                    signal bit_field_read_mask: std_logic_vector(31 downto 0);
                    signal bit_field_write_mask: std_logic_vector(31 downto 0);
                    signal bit_field_write_data: std_logic_vector(31 downto 0);
                    signal bit_field_read_data: std_logic_vector(31 downto 0);
                    signal bit_field_value: std_logic_vector(31 downto 0);
                  begin
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
                        OFFSET_ADDRESS  => x"0a0"+64*i+4*(2*j+k),
                        BUS_WIDTH       => 32,
                        DATA_WIDTH      => 32
                      )
                      port map (
                        i_clk                   => i_clk,
                        i_rst_n                 => i_rst_n,
                        i_register_valid        => register_valid,
                        i_register_access       => register_access,
                        i_register_address      => register_address,
                        i_register_write_data   => register_write_data,
                        i_register_strobe       => register_strobe,
                        o_register_active       => register_active(36+6*i+2*j+k),
                        o_register_ready        => register_ready(36+6*i+2*j+k),
                        o_register_status       => register_status(2*(36+6*i+2*j+k)+1 downto 2*(36+6*i+2*j+k)),
                        o_register_read_data    => register_read_data(32*(36+6*i+2*j+k)+31 downto 32*(36+6*i+2*j+k)),
                        o_register_value        => register_value(32*(36+6*i+2*j+k)+0+31 downto 32*(36+6*i+2*j+k)+0),
                        o_bit_field_valid       => bit_field_valid,
                        o_bit_field_read_mask   => bit_field_read_mask,
                        o_bit_field_write_mask  => bit_field_write_mask,
                        o_bit_field_write_data  => bit_field_write_data,
                        i_bit_field_read_data   => bit_field_read_data,
                        i_bit_field_value       => bit_field_value
                      );
                    g_bit_field_0: block
                    begin
                      u_bit_field: entity work.rggen_bit_field
                        generic map (
                          WIDTH           => 1,
                          INITIAL_VALUE   => slice(x"0", 1, 0),
                          SW_WRITE_ONCE   => false,
                          TRIGGER         => false
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
                          i_hw_write_enable => "0",
                          i_hw_write_data   => (others => '0'),
                          i_hw_set          => (others => '0'),
                          i_hw_clear        => (others => '0'),
                          i_value           => (others => '0'),
                          i_mask            => (others => '1'),
                          o_value           => o_register_file_3_register_file_0_register_0_bit_field_0(1*(4*i+2*j+k)+0 downto 1*(4*i+2*j+k)),
                          o_value_unmasked  => open
                        );
                    end block;
                  end generate;
                end generate;
              end block;
            end block;
            g_register_1: block
            begin
              g: for j in 0 to 1 generate
                signal bit_field_valid: std_logic;
                signal bit_field_read_mask: std_logic_vector(31 downto 0);
                signal bit_field_write_mask: std_logic_vector(31 downto 0);
                signal bit_field_write_data: std_logic_vector(31 downto 0);
                signal bit_field_read_data: std_logic_vector(31 downto 0);
                signal bit_field_value: std_logic_vector(31 downto 0);
              begin
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
                    OFFSET_ADDRESS  => x"0a0"+64*i+x"010"+8*j,
                    BUS_WIDTH       => 32,
                    DATA_WIDTH      => 32
                  )
                  port map (
                    i_clk                   => i_clk,
                    i_rst_n                 => i_rst_n,
                    i_register_valid        => register_valid,
                    i_register_access       => register_access,
                    i_register_address      => register_address,
                    i_register_write_data   => register_write_data,
                    i_register_strobe       => register_strobe,
                    o_register_active       => register_active(36+6*i+4+j),
                    o_register_ready        => register_ready(36+6*i+4+j),
                    o_register_status       => register_status(2*(36+6*i+4+j)+1 downto 2*(36+6*i+4+j)),
                    o_register_read_data    => register_read_data(32*(36+6*i+4+j)+31 downto 32*(36+6*i+4+j)),
                    o_register_value        => register_value(32*(36+6*i+4+j)+0+31 downto 32*(36+6*i+4+j)+0),
                    o_bit_field_valid       => bit_field_valid,
                    o_bit_field_read_mask   => bit_field_read_mask,
                    o_bit_field_write_mask  => bit_field_write_mask,
                    o_bit_field_write_data  => bit_field_write_data,
                    i_bit_field_read_data   => bit_field_read_data,
                    i_bit_field_value       => bit_field_value
                  );
                g_bit_field_0: block
                begin
                  u_bit_field: entity work.rggen_bit_field
                    generic map (
                      WIDTH           => 1,
                      INITIAL_VALUE   => slice(x"0", 1, 0),
                      SW_WRITE_ONCE   => false,
                      TRIGGER         => false
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
                      i_hw_write_enable => "0",
                      i_hw_write_data   => (others => '0'),
                      i_hw_set          => (others => '0'),
                      i_hw_clear        => (others => '0'),
                      i_value           => (others => '0'),
                      i_mask            => (others => '1'),
                      o_value           => o_register_file_3_register_1_bit_field_0(1*(2*i+j)+0 downto 1*(2*i+j)),
                      o_value_unmasked  => open
                    );
                end block;
              end generate;
            end block;
          end generate;
        end block;
      CODE
    end
  end
end
