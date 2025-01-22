# frozen_string_literal: true

RSpec.describe 'regiter_map/name' do
  include_context 'clean-up builder'
  include_context 'register map common'

  before(:all) do
    RgGen.enable(:register_block, :name)
    RgGen.enable(:register_file, :name)
    RgGen.enable(:register, :name)
    RgGen.enable(:bit_field, :name)
  end

  let(:vhdl_keywords) do
    [
      'abs', 'access', 'after', 'alias', 'all', 'and', 'architecture', 'array', 'assert',
      'assume', 'attribute', 'begin', 'block', 'body', 'buffer', 'bus', 'case',
      'component', 'configuration', 'constant', 'context', 'cover', 'default',
      'disconnect', 'downto', 'else', 'elsif', 'end', 'entity', 'exit', 'fairness',
      'file', 'for', 'force', 'function', 'generate', 'generic', 'group', 'guarded',
      'if', 'impure', 'in', 'inertial', 'inout', 'is', 'label', 'library', 'linkage',
      'literal', 'loop', 'map', 'mod', 'nand', 'new', 'next', 'nor', 'not', 'null',
      'of', 'on', 'open', 'or', 'others', 'out', 'package', 'parameter', 'port',
      'postponed', 'procedure', 'process', 'property', 'protected', 'private', 'pure',
      'range', 'record', 'register', 'reject', 'release', 'rem', 'report', 'restrict',
      'return', 'rol', 'ror', 'select', 'sequence', 'severity', 'signal', 'shared',
      'sla', 'sll', 'sra', 'srl', 'strong', 'subtype', 'then', 'to', 'transport',
      'type', 'unaffected', 'units', 'until', 'use', 'variable', 'view', 'vpkg',
      'vmode', 'vprop', 'vunit', 'wait', 'when', 'while', 'with', 'xnor', 'xor'
    ]
  end

  def random_updown_case(keyword)
    keyword
      .each_char
      .map { |c| [true, false].sample && c.upcase || c }
      .join
  end

  context 'レジスタブロック名がVHDLの予約語に一致する場合' do
    it 'SourceErrorを起こす' do
      vhdl_keywords.each do |keyword|
        expect {
          create_register_map do
            register_block { name keyword }
          end
        }.to raise_source_error "vhdl keyword is not allowed for register block name: #{keyword}"

        kw = random_updown_case(keyword)
        expect {
          create_register_map do
            register_block { name kw }
          end
        }.to raise_source_error "vhdl keyword is not allowed for register block name: #{keyword}"
      end
    end
  end

  context 'レジスタファイル名がVHDLの予約語に一致する場合' do
    it 'SourceErrorを起こす' do
      vhdl_keywords.each do |keyword|
        expect {
          create_register_map do
            register_block do
              name 'block_0'
              register_file { name keyword }
            end
          end
        }.to raise_source_error "vhdl keyword is not allowed for register file name: #{keyword}"

        kw = random_updown_case(keyword)
        expect {
          create_register_map do
            register_block do
              name 'block_0'
              register_file { name kw }
            end
          end
        }.to raise_source_error "vhdl keyword is not allowed for register file name: #{keyword}"
      end
    end
  end

  context 'レジスタ名がVHDLの予約語に一致する場合' do
    it 'SourceErrorを起こす' do
      vhdl_keywords.each do |keyword|
        expect {
          create_register_map do
            register_block do
              name 'block_0'
              register { name keyword }
            end
          end
        }.to raise_source_error "vhdl keyword is not allowed for register name: #{keyword}"

        kw = random_updown_case(keyword)
        expect {
          create_register_map do
            register_block do
              name 'block_0'
              register { name kw }
            end
          end
        }.to raise_source_error "vhdl keyword is not allowed for register name: #{keyword}"
      end
    end
  end

  context 'ビットフィールド名がVHDLの予約語に一致する場合' do
    it 'SourceErrorを起こす' do
      vhdl_keywords.each do |keyword|
        expect {
          create_register_map do
            register_block do
              name 'block_0'
              register do
                name 'register_0'
                bit_field { name keyword }
              end
            end
          end
        }.to raise_source_error "vhdl keyword is not allowed for bit field name: #{keyword}"

        kw = random_updown_case(keyword)
        expect {
          create_register_map do
            register_block do
              name 'block_0'
              register do
                name 'register_0'
                bit_field { name kw }
              end
            end
          end
        }.to raise_source_error "vhdl keyword is not allowed for bit field name: #{keyword}"
      end
    end
  end
end
