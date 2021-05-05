# frozen_string_literal: true

RSpec.describe RgGen::VHDL::Utility::LocalScope do
  let(:signals) do
    [:bar, :baz].map do |name|
      RgGen::VHDL::Utility::DataObject
        .new(:signal, name: name).declaration
    end
  end

  let(:loop_size) do
    { i: 1, j: 2, k: 3 }
  end

  def local_scope(name, &block)
    described_class.new(name: name, &block).to_code
  end

  it 'ローカルスコープを構成するコード片を返す' do
    expect(
      local_scope(:foo)
    ).to match_string(<<~'SCOPE')
      foo: block
      begin
      end block;
    SCOPE

    expect(
      local_scope(:foo) do |s|
        s.signals signals
      end
    ).to match_string(<<~'SCOPE')
      foo: block
        signal bar: std_logic;
        signal baz: std_logic;
      begin
      end block;
    SCOPE

    expect(
      local_scope(:foo) do |s|
        s.loop_size loop_size
      end
    ).to match_string(<<~'SCOPE')
      foo: block
      begin
        g: for i in 0 to 0 generate
        begin
          g: for j in 0 to 1 generate
          begin
            g: for k in 0 to 2 generate
            begin
            end generate;
          end generate;
        end generate;
      end block;
    SCOPE

    expect(
      local_scope(:foo) do |s|
        s.loop_size loop_size
        s.signals signals
      end
    ).to match_string(<<~'SCOPE')
      foo: block
      begin
        g: for i in 0 to 0 generate
        begin
          g: for j in 0 to 1 generate
          begin
            g: for k in 0 to 2 generate
              signal bar: std_logic;
              signal baz: std_logic;
            begin
            end generate;
          end generate;
        end generate;
      end block;
    SCOPE

    expect(
      local_scope(:foo) do |s|
        s.signals signals
        s.body { "bar <= '1';" }
        s.body { |c| c << "baz <= '0';" }
      end
    ).to match_string(<<~'SCOPE')
      foo: block
        signal bar: std_logic;
        signal baz: std_logic;
      begin
        bar <= '1';
        baz <= '0';
      end block;
    SCOPE

    expect(
      local_scope(:foo) do |s|
        s.body { "bar <= '1';" }
        s.body { |c| c << "baz <= '0';" }
        s.loop_size loop_size
        s.signals signals
      end
    ).to match_string(<<~'SCOPE')
      foo: block
      begin
        g: for i in 0 to 0 generate
        begin
          g: for j in 0 to 1 generate
          begin
            g: for k in 0 to 2 generate
              signal bar: std_logic;
              signal baz: std_logic;
            begin
              bar <= '1';
              baz <= '0';
            end generate;
          end generate;
        end generate;
      end block;
    SCOPE
  end
end
