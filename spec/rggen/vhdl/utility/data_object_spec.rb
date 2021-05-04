# frozen_string_literal: true

RSpec.describe RgGen::VHDL::Utility::DataObject do
  def signal(name, &block)
    described_class.new(:signal, name: name, &block)
  end

  def input(name, &block)
    described_class.new(:port, name: name, direction: :in, &block)
  end

  def output(name, &block)
    described_class.new(:port, name: name, direction: :out, &block)
  end

  def generic(name, &block)
    described_class.new(:generic, name: name, &block)
  end

  def data_object(name, &block)
    object_type = [:signal, :port, :generic].sample
    described_class.new(object_type, name: name, &block)
  end

  describe '#declaration' do
    context '信号の場合' do
      it '信号宣言を返す' do
        expect(signal('foo')).to match_declaration('signal foo: std_logic')
        expect(signal('foo') { |o| o.width 2 }).to match_declaration('signal foo: std_logic_vector(1 downto 0)')
        expect(signal('foo') { |o| o.width 'WIDTH' }).to match_declaration('signal foo: std_logic_vector(WIDTH-1 downto 0)')

        expect(signal('foo') { |o| o.array_size [2] }).to match_declaration('signal foo: std_logic_vector(1 downto 0)')
        expect(signal('foo') { |o| o.array_size [2]; o.width 2 }).to match_declaration('signal foo: std_logic_vector(3 downto 0)')
        expect(signal('foo') { |o| o.array_size [2]; o.width 'WIDTH' }).to match_declaration('signal foo: std_logic_vector(WIDTH*2-1 downto 0)')

        expect(signal('foo') { |o| o.array_size [2, 3] }).to match_declaration('signal foo: std_logic_vector(5 downto 0)')
        expect(signal('foo') { |o| o.array_size [2, 3]; o.width 2 }).to match_declaration('signal foo: std_logic_vector(11 downto 0)')
        expect(signal('foo') { |o| o.array_size [2, 3]; o.width 'WIDTH' }).to match_declaration('signal foo: std_logic_vector(WIDTH*2*3-1 downto 0)')

        expect(signal('foo') { |o| o.array_size ['ARRAY_SIZE'] }).to match_declaration('signal foo: std_logic_vector(ARRAY_SIZE-1 downto 0)')
        expect(signal('foo') { |o| o.array_size ['ARRAY_SIZE']; o.width 1 }).to match_declaration('signal foo: std_logic_vector(1*ARRAY_SIZE-1 downto 0)')
        expect(signal('foo') { |o| o.array_size ['ARRAY_SIZE']; o.width 2 }).to match_declaration('signal foo: std_logic_vector(2*ARRAY_SIZE-1 downto 0)')
        expect(signal('foo') { |o| o.array_size ['ARRAY_SIZE']; o.width 'WIDTH' }).to match_declaration('signal foo: std_logic_vector(WIDTH*ARRAY_SIZE-1 downto 0)')
      end
    end

    context '入出力ポートの場合' do
      it 'ポート宣言を返す' do
        expect(input('foo')).to match_declaration('foo: in std_logic')
        expect(input('foo') { |o| o.width 2 }).to match_declaration('foo: in std_logic_vector(1 downto 0)')
        expect(input('foo') { |o| o.width 'WIDTH' }).to match_declaration('foo: in std_logic_vector(WIDTH-1 downto 0)')

        expect(input('foo') { |o| o.array_size [2] }).to match_declaration('foo: in std_logic_vector(1 downto 0)')
        expect(input('foo') { |o| o.array_size [2]; o.width 2 }).to match_declaration('foo: in std_logic_vector(3 downto 0)')
        expect(input('foo') { |o| o.array_size [2]; o.width 'WIDTH' }).to match_declaration('foo: in std_logic_vector(WIDTH*2-1 downto 0)')

        expect(input('foo') { |o| o.array_size [2, 3] }).to match_declaration('foo: in std_logic_vector(5 downto 0)')
        expect(input('foo') { |o| o.array_size [2, 3]; o.width 2 }).to match_declaration('foo: in std_logic_vector(11 downto 0)')
        expect(input('foo') { |o| o.array_size [2, 3]; o.width 'WIDTH' }).to match_declaration('foo: in std_logic_vector(WIDTH*2*3-1 downto 0)')

        expect(input('foo') { |o| o.array_size ['ARRAY_SIZE'] }).to match_declaration('foo: in std_logic_vector(ARRAY_SIZE-1 downto 0)')
        expect(input('foo') { |o| o.array_size ['ARRAY_SIZE']; o.width 1 }).to match_declaration('foo: in std_logic_vector(1*ARRAY_SIZE-1 downto 0)')
        expect(input('foo') { |o| o.array_size ['ARRAY_SIZE']; o.width 2 }).to match_declaration('foo: in std_logic_vector(2*ARRAY_SIZE-1 downto 0)')
        expect(input('foo') { |o| o.array_size ['ARRAY_SIZE']; o.width 'WIDTH' }).to match_declaration('foo: in std_logic_vector(WIDTH*ARRAY_SIZE-1 downto 0)')

        expect(output('foo')).to match_declaration('foo: out std_logic')
        expect(output('foo') { |o| o.width 2 }).to match_declaration('foo: out std_logic_vector(1 downto 0)')
        expect(output('foo') { |o| o.width 'WIDTH' }).to match_declaration('foo: out std_logic_vector(WIDTH-1 downto 0)')

        expect(output('foo') { |o| o.array_size [2] }).to match_declaration('foo: out std_logic_vector(1 downto 0)')
        expect(output('foo') { |o| o.array_size [2]; o.width 2 }).to match_declaration('foo: out std_logic_vector(3 downto 0)')
        expect(output('foo') { |o| o.array_size [2]; o.width 'WIDTH' }).to match_declaration('foo: out std_logic_vector(WIDTH*2-1 downto 0)')

        expect(output('foo') { |o| o.array_size [2, 3] }).to match_declaration('foo: out std_logic_vector(5 downto 0)')
        expect(output('foo') { |o| o.array_size [2, 3]; o.width 2 }).to match_declaration('foo: out std_logic_vector(11 downto 0)')
        expect(output('foo') { |o| o.array_size [2, 3]; o.width 'WIDTH' }).to match_declaration('foo: out std_logic_vector(WIDTH*2*3-1 downto 0)')

        expect(output('foo') { |o| o.array_size ['ARRAY_SIZE'] }).to match_declaration('foo: out std_logic_vector(ARRAY_SIZE-1 downto 0)')
        expect(output('foo') { |o| o.array_size ['ARRAY_SIZE']; o.width 1 }).to match_declaration('foo: out std_logic_vector(1*ARRAY_SIZE-1 downto 0)')
        expect(output('foo') { |o| o.array_size ['ARRAY_SIZE']; o.width 2 }).to match_declaration('foo: out std_logic_vector(2*ARRAY_SIZE-1 downto 0)')
        expect(output('foo') { |o| o.array_size ['ARRAY_SIZE']; o.width 'WIDTH' }).to match_declaration('foo: out std_logic_vector(WIDTH*ARRAY_SIZE-1 downto 0)')
      end
    end

    context 'ジェネリックの場合' do
      let(:default_value) do
        "(default => '0')"
      end

      it 'ジェネリック宣言を返す' do
        expect(generic('foo') { |o| o.width 2; o.default default_value }).to match_declaration("foo: unsigned(1 downto 0) := #{default_value}")
        expect(generic('foo') { |o| o.width 'WIDTH'; o.default default_value }).to match_declaration("foo: unsigned(WIDTH-1 downto 0) := #{default_value}")

        expect(generic('foo') { |o| o.array_size [2]; o.default default_value }).to match_declaration("foo: unsigned(1 downto 0) := #{default_value}")
        expect(generic('foo') { |o| o.array_size [2]; o.width 2; o.default default_value }).to match_declaration("foo: unsigned(3 downto 0) := #{default_value}")
        expect(generic('foo') { |o| o.array_size [2]; o.width 'WIDTH'; o.default default_value }).to match_declaration("foo: unsigned(WIDTH*2-1 downto 0) := #{default_value}")

        expect(generic('foo') { |o| o.array_size [2, 3]; o.default default_value }).to match_declaration("foo: unsigned(5 downto 0) := #{default_value}")
        expect(generic('foo') { |o| o.array_size [2, 3]; o.width 2; o.default default_value }).to match_declaration("foo: unsigned(11 downto 0) := #{default_value}")
        expect(generic('foo') { |o| o.array_size [2, 3]; o.width 'WIDTH'; o.default default_value }).to match_declaration("foo: unsigned(WIDTH*2*3-1 downto 0) := #{default_value}")

        expect(generic('foo') { |o| o.array_size ['ARRAY_SIZE']; o.default default_value }).to match_declaration("foo: unsigned(ARRAY_SIZE-1 downto 0) := #{default_value}")
        expect(generic('foo') { |o| o.array_size ['ARRAY_SIZE']; o.width 1; o.default default_value }).to match_declaration("foo: unsigned(1*ARRAY_SIZE-1 downto 0) := #{default_value}")
        expect(generic('foo') { |o| o.array_size ['ARRAY_SIZE']; o.width 2; o.default default_value }).to match_declaration("foo: unsigned(2*ARRAY_SIZE-1 downto 0) := #{default_value}")
        expect(generic('foo') { |o| o.array_size ['ARRAY_SIZE']; o.width 'WIDTH'; o.default default_value }).to match_declaration("foo: unsigned(WIDTH*ARRAY_SIZE-1 downto 0) := #{default_value}")

        expect(generic('foo') { |o| o.default 'x"abcd"' }).to match_declaration('foo: unsigned := x"abcd"')
        expect(generic('foo') { |o| o.type :boolean; o.default true }).to match_declaration('foo: boolean := true')
        expect(generic('foo') { |o| o.type :positive; o.default 8 }).to match_declaration('foo: positive := 8')
      end
    end
  end

  describe '#identifier' do
    it '自身の識別子を返す' do
      expect(data_object('foo')).to match_identifier('foo')
      expect(data_object('foo') {|o| o.width 2 }).to match_identifier('foo')
      expect(data_object('foo') {|o| o.width 2; o.array_size [2, 3] }).to match_identifier('foo')
      expect(data_object('foo') {|o| o.width 2; o.array_size [2, 3] }.identifier[[:i, :j]]).to match_identifier('foo(2*(3*i+j)+1 downto 2*(3*i+j))')
      expect(data_object('foo') {|o| o.array_size [2, 3] }.identifier[[:i, :j]]).to match_identifier('foo(3*i+j)')
    end
  end
end
