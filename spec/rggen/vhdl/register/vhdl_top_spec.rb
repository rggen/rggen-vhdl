# frozen_string_literal: true

RSpec.describe 'register/vhdl_top' do
  include_context 'vhdl common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width])
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

  def create_registers(&body)
    create_vhdl(&body).registers
  end

  context 'レジスタがビットフィールドを持つ場合' do
    def check_bit_field_signals(register, width)
      expect(register).to have_signal(:bit_field_valid)
      expect(register).to have_signal(:bit_field_read_mask, width: width)
      expect(register).to have_signal(:bit_field_write_mask, width: width)
      expect(register).to have_signal(:bit_field_write_data, width: width)
      expect(register).to have_signal(:bit_field_read_data, width: width)
      expect(register).to have_signal(:bit_field_value, width: width)
    end

    it 'ビットフィールドアクセス用の信号群を持つ' do
      registers = create_registers do
        name 'block_0'
        byte_size 256

        register do
          name 'register_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end

        register do
          name 'register_1'
          offset_address 0x10
          bit_field { name 'bit_field_0'; bit_assignment lsb: 32; type :rw; initial_value 0 }
        end

        register do
          name 'register_2'
          offset_address 0x20
          size [2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end

        register do
          name 'register_3'
          offset_address 0x30
          size [2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 32; type :rw; initial_value 0 }
        end

        register do
          name 'register_4'
          offset_address 0x40
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end

        register do
          name 'register_5'
          offset_address 0x50
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 32; type :rw; initial_value 0 }
        end
      end

      check_bit_field_signals(registers[0], 32)
      check_bit_field_signals(registers[1], 64)
      check_bit_field_signals(registers[2], 32)
      check_bit_field_signals(registers[3], 64)
      check_bit_field_signals(registers[4], 32)
      check_bit_field_signals(registers[5], 64)
    end
  end

  context 'レジスタがビットフィールドを持たない場合' do
    it 'ビットフィールドアクセス用の信号群を持たない' do
      registers = create_registers do
        name 'block_0'
        byte_size 256
        register do
          name 'register_0'
          offset_address 0x00
          size [64]
          type :external
        end
      end

      expect(registers[0]).to not_have_signal(:bit_field_valid)
      expect(registers[0]).to not_have_signal(:bit_field_read_mask, width: 32)
      expect(registers[0]).to not_have_signal(:bit_field_write_mask, width: 32)
      expect(registers[0]).to not_have_signal(:bit_field_write_data, width: 32)
      expect(registers[0]).to not_have_signal(:bit_field_read_data, width: 32)
      expect(registers[0]).to not_have_signal(:bit_field_value, width: 32)
    end
  end

  describe '#generate_code' do
    it 'レジスタ階層のコードを出力する' do
      registers = create_registers do
        name 'block_0'
        byte_size 256

        register do
          name 'register_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rw; initial_value 0 }
        end

        register do
          name 'register_1'
          offset_address 0x10
          type :external
          size [4]
        end

        register do
          name 'register_2'
          offset_address 0x20
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rw; initial_value 0 }
        end

        register do
          name 'register_3'
          offset_address 0x30
          type [:indirect, 'register_0.bit_field_0', 'register_0.bit_field_1']
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rw; initial_value 0 }
        end

        register do
          name 'register_4'
          offset_address 0x40
          bit_field { bit_assignment lsb: 0, width: 2; type :rw; initial_value 0 }
        end

        register_file do
          name 'register_file_5'
          offset_address 0x50
          size [2, 2]
          register_file do
            name 'register_file_0'
            offset_address 0x00
            register do
              name 'register_0'
              offset_address 0x00
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 2; type :rw; initial_value 0 }
            end
          end
        end
      end

      expect(registers[0]).to generate_code(:register_file, :top_down, <<~'CODE')
        g_register_0: block
          signal bit_field_valid: std_logic;
          signal bit_field_read_mask: std_logic_vector(31 downto 0);
          signal bit_field_write_mask: std_logic_vector(31 downto 0);
          signal bit_field_write_data: std_logic_vector(31 downto 0);
          signal bit_field_read_data: std_logic_vector(31 downto 0);
          signal bit_field_value: std_logic_vector(31 downto 0);
        begin
          u_register: entity work.rggen_default_register
            generic map (
              READABLE        => true,
              WRITABLE        => true,
              ADDRESS_WIDTH   => 8,
              OFFSET_ADDRESS  => x"00",
              BUS_WIDTH       => 32,
              DATA_WIDTH      => 32,
              VALID_BITS      => x"00000303",
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
          g_bit_field_0: block
          begin
            u_bit_field: entity work.rggen_bit_field
              generic map (
                WIDTH           => 2,
                INITIAL_VALUE   => slice(x"0", 2, 0),
                SW_READ_ACTION  => RGGEN_READ_DEFAULT,
                SW_WRITE_ONCE   => false
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
                i_hw_write_enable => "0",
                i_hw_write_data   => (others => '0'),
                i_hw_set          => (others => '0'),
                i_hw_clear        => (others => '0'),
                i_value           => (others => '0'),
                i_mask            => (others => '1'),
                o_value           => o_register_0_bit_field_0,
                o_value_unmasked  => open
              );
          end block;
          g_bit_field_1: block
          begin
            u_bit_field: entity work.rggen_bit_field
              generic map (
                WIDTH           => 2,
                INITIAL_VALUE   => slice(x"0", 2, 0),
                SW_READ_ACTION  => RGGEN_READ_DEFAULT,
                SW_WRITE_ONCE   => false
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
                i_hw_write_enable => "0",
                i_hw_write_data   => (others => '0'),
                i_hw_set          => (others => '0'),
                i_hw_clear        => (others => '0'),
                i_value           => (others => '0'),
                i_mask            => (others => '1'),
                o_value           => o_register_0_bit_field_1,
                o_value_unmasked  => open
              );
          end block;
        end block;
      CODE

      expect(registers[1]).to generate_code(:register_file, :top_down, <<~'CODE')
        g_register_1: block
        begin
          u_register: entity work.rggen_external_register
            generic map (
              ADDRESS_WIDTH => 8,
              BUS_WIDTH     => 32,
              START_ADDRESS => x"10",
              BYTE_SIZE     => 16
            )
            port map (
              i_clk                 => i_clk,
              i_rst_n               => i_rst_n,
              i_register_valid      => register_valid,
              i_register_access     => register_access,
              i_register_address    => register_address,
              i_register_write_data => register_write_data,
              i_register_strobe     => register_strobe,
              o_register_active     => register_active(1),
              o_register_ready      => register_ready(1),
              o_register_status     => register_status(3 downto 2),
              o_register_read_data  => register_read_data(63 downto 32),
              o_register_value      => register_value(63 downto 32),
              o_external_valid      => o_register_1_valid,
              o_external_access     => o_register_1_access,
              o_external_address    => o_register_1_address,
              o_external_data       => o_register_1_data,
              o_external_strobe     => o_register_1_strobe,
              i_external_ready      => i_register_1_ready,
              i_external_status     => i_register_1_status,
              i_external_data       => i_register_1_data
            );
        end block;
      CODE

      expect(registers[2]).to generate_code(:register_file, :top_down, <<~'CODE')
        g_register_2: block
        begin
          g: for i in 0 to 3 generate
            signal bit_field_valid: std_logic;
            signal bit_field_read_mask: std_logic_vector(31 downto 0);
            signal bit_field_write_mask: std_logic_vector(31 downto 0);
            signal bit_field_write_data: std_logic_vector(31 downto 0);
            signal bit_field_read_data: std_logic_vector(31 downto 0);
            signal bit_field_value: std_logic_vector(31 downto 0);
          begin
            u_register: entity work.rggen_default_register
              generic map (
                READABLE        => true,
                WRITABLE        => true,
                ADDRESS_WIDTH   => 8,
                OFFSET_ADDRESS  => x"20",
                BUS_WIDTH       => 32,
                DATA_WIDTH      => 32,
                VALID_BITS      => x"00000303",
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
                o_register_active       => register_active(2+i),
                o_register_ready        => register_ready(2+i),
                o_register_status       => register_status(2*(2+i)+1 downto 2*(2+i)),
                o_register_read_data    => register_read_data(32*(2+i)+31 downto 32*(2+i)),
                o_register_value        => register_value(32*(2+i)+0+31 downto 32*(2+i)+0),
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
                  WIDTH           => 2,
                  INITIAL_VALUE   => slice(x"0", 2, 0),
                  SW_READ_ACTION  => RGGEN_READ_DEFAULT,
                  SW_WRITE_ONCE   => false
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
                  i_hw_write_enable => "0",
                  i_hw_write_data   => (others => '0'),
                  i_hw_set          => (others => '0'),
                  i_hw_clear        => (others => '0'),
                  i_value           => (others => '0'),
                  i_mask            => (others => '1'),
                  o_value           => o_register_2_bit_field_0(2*(i)+1 downto 2*(i)),
                  o_value_unmasked  => open
                );
            end block;
            g_bit_field_1: block
            begin
              u_bit_field: entity work.rggen_bit_field
                generic map (
                  WIDTH           => 2,
                  INITIAL_VALUE   => slice(x"0", 2, 0),
                  SW_READ_ACTION  => RGGEN_READ_DEFAULT,
                  SW_WRITE_ONCE   => false
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
                  i_hw_write_enable => "0",
                  i_hw_write_data   => (others => '0'),
                  i_hw_set          => (others => '0'),
                  i_hw_clear        => (others => '0'),
                  i_value           => (others => '0'),
                  i_mask            => (others => '1'),
                  o_value           => o_register_2_bit_field_1(2*(i)+1 downto 2*(i)),
                  o_value_unmasked  => open
                );
            end block;
          end generate;
        end block;
      CODE

      expect(registers[3]).to generate_code(:register_file, :top_down, <<~'CODE')
        g_register_3: block
        begin
          g: for i in 0 to 1 generate
          begin
            g: for j in 0 to 1 generate
              signal indirect_match: std_logic_vector(1 downto 0);
              signal bit_field_valid: std_logic;
              signal bit_field_read_mask: std_logic_vector(31 downto 0);
              signal bit_field_write_mask: std_logic_vector(31 downto 0);
              signal bit_field_write_data: std_logic_vector(31 downto 0);
              signal bit_field_read_data: std_logic_vector(31 downto 0);
              signal bit_field_value: std_logic_vector(31 downto 0);
            begin
              indirect_match(0) <= '1' when unsigned(register_value(1 downto 0)) = i else '0';
              indirect_match(1) <= '1' when unsigned(register_value(9 downto 8)) = j else '0';
              u_register: entity work.rggen_indirect_register
                generic map (
                  READABLE              => true,
                  WRITABLE              => true,
                  ADDRESS_WIDTH         => 8,
                  OFFSET_ADDRESS        => x"30",
                  BUS_WIDTH             => 32,
                  DATA_WIDTH            => 32,
                  VALID_BITS            => x"00000303",
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
                  o_register_active       => register_active(6+2*i+j),
                  o_register_ready        => register_ready(6+2*i+j),
                  o_register_status       => register_status(2*(6+2*i+j)+1 downto 2*(6+2*i+j)),
                  o_register_read_data    => register_read_data(32*(6+2*i+j)+31 downto 32*(6+2*i+j)),
                  o_register_value        => register_value(32*(6+2*i+j)+0+31 downto 32*(6+2*i+j)+0),
                  i_indirect_match        => indirect_match,
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
                    WIDTH           => 2,
                    INITIAL_VALUE   => slice(x"0", 2, 0),
                    SW_READ_ACTION  => RGGEN_READ_DEFAULT,
                    SW_WRITE_ONCE   => false
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
                    i_hw_write_enable => "0",
                    i_hw_write_data   => (others => '0'),
                    i_hw_set          => (others => '0'),
                    i_hw_clear        => (others => '0'),
                    i_value           => (others => '0'),
                    i_mask            => (others => '1'),
                    o_value           => o_register_3_bit_field_0(2*(2*i+j)+1 downto 2*(2*i+j)),
                    o_value_unmasked  => open
                  );
              end block;
              g_bit_field_1: block
              begin
                u_bit_field: entity work.rggen_bit_field
                  generic map (
                    WIDTH           => 2,
                    INITIAL_VALUE   => slice(x"0", 2, 0),
                    SW_READ_ACTION  => RGGEN_READ_DEFAULT,
                    SW_WRITE_ONCE   => false
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
                    i_hw_write_enable => "0",
                    i_hw_write_data   => (others => '0'),
                    i_hw_set          => (others => '0'),
                    i_hw_clear        => (others => '0'),
                    i_value           => (others => '0'),
                    i_mask            => (others => '1'),
                    o_value           => o_register_3_bit_field_1(2*(2*i+j)+1 downto 2*(2*i+j)),
                    o_value_unmasked  => open
                  );
              end block;
            end generate;
          end generate;
        end block;
      CODE

      expect(registers[4]).to generate_code(:register_file, :top_down, <<~'CODE')
        g_register_4: block
          signal bit_field_valid: std_logic;
          signal bit_field_read_mask: std_logic_vector(31 downto 0);
          signal bit_field_write_mask: std_logic_vector(31 downto 0);
          signal bit_field_write_data: std_logic_vector(31 downto 0);
          signal bit_field_read_data: std_logic_vector(31 downto 0);
          signal bit_field_value: std_logic_vector(31 downto 0);
        begin
          u_register: entity work.rggen_default_register
            generic map (
              READABLE        => true,
              WRITABLE        => true,
              ADDRESS_WIDTH   => 8,
              OFFSET_ADDRESS  => x"40",
              BUS_WIDTH       => 32,
              DATA_WIDTH      => 32,
              VALID_BITS      => x"00000003",
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
              o_register_value        => register_value(351 downto 320),
              o_bit_field_valid       => bit_field_valid,
              o_bit_field_read_mask   => bit_field_read_mask,
              o_bit_field_write_mask  => bit_field_write_mask,
              o_bit_field_write_data  => bit_field_write_data,
              i_bit_field_read_data   => bit_field_read_data,
              i_bit_field_value       => bit_field_value
            );
          g_register_4: block
          begin
            u_bit_field: entity work.rggen_bit_field
              generic map (
                WIDTH           => 2,
                INITIAL_VALUE   => slice(x"0", 2, 0),
                SW_READ_ACTION  => RGGEN_READ_DEFAULT,
                SW_WRITE_ONCE   => false
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
                i_hw_write_enable => "0",
                i_hw_write_data   => (others => '0'),
                i_hw_set          => (others => '0'),
                i_hw_clear        => (others => '0'),
                i_value           => (others => '0'),
                i_mask            => (others => '1'),
                o_value           => o_register_4,
                o_value_unmasked  => open
              );
          end block;
        end block;
      CODE

      expect(registers[5]).to generate_code(:register_file, :top_down, <<~'CODE')
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
              u_register: entity work.rggen_default_register
                generic map (
                  READABLE        => true,
                  WRITABLE        => true,
                  ADDRESS_WIDTH   => 8,
                  OFFSET_ADDRESS  => x"50"+16*(2*i+j),
                  BUS_WIDTH       => 32,
                  DATA_WIDTH      => 32,
                  VALID_BITS      => x"00000003",
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
                  o_register_active       => register_active(11+4*(2*i+j)+2*k+l),
                  o_register_ready        => register_ready(11+4*(2*i+j)+2*k+l),
                  o_register_status       => register_status(2*(11+4*(2*i+j)+2*k+l)+1 downto 2*(11+4*(2*i+j)+2*k+l)),
                  o_register_read_data    => register_read_data(32*(11+4*(2*i+j)+2*k+l)+31 downto 32*(11+4*(2*i+j)+2*k+l)),
                  o_register_value        => register_value(32*(11+4*(2*i+j)+2*k+l)+0+31 downto 32*(11+4*(2*i+j)+2*k+l)+0),
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
                    WIDTH           => 2,
                    INITIAL_VALUE   => slice(x"0", 2, 0),
                    SW_READ_ACTION  => RGGEN_READ_DEFAULT,
                    SW_WRITE_ONCE   => false
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
                    i_hw_write_enable => "0",
                    i_hw_write_data   => (others => '0'),
                    i_hw_set          => (others => '0'),
                    i_hw_clear        => (others => '0'),
                    i_value           => (others => '0'),
                    i_mask            => (others => '1'),
                    o_value           => o_register_file_5_register_file_0_register_0_bit_field_0(2*(8*i+4*j+2*k+l)+1 downto 2*(8*i+4*j+2*k+l)),
                    o_value_unmasked  => open
                  );
              end block;
            end generate;
          end generate;
        end block;
      CODE
    end
  end
end
