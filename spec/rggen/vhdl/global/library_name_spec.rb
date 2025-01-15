# frozen_string_literal: true

RSpec.describe 'global/library_name' do
  include_context 'configuration common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, :library_name)
  end

  describe '#library_name' do
    specify 'デフォルト値は:workである' do
      configuration = create_configuration
      expect(configuration).to have_property(:library_name, 'work')
    end

    it '入力されたライブラリ名を返す' do
      ['work', random_string(/[a-z]\w+/i)].each do |name|
        configuration = create_configuration(library_name: name)
        expect(configuration).to have_property(:library_name, name)
      end
    end
  end

  describe '#use_default_library?' do
    context 'ライブラリ名が未指定の場合' do
      it '真を返す' do
        configuration = create_configuration
        expect(configuration).to have_property(:use_default_library?, true)
      end
    end

    context 'ライブラリ名がworkの場合' do
      it '真を返す' do
        ['work', 'WORK', random_string(/work/i)].each do |name|
          configuration = create_configuration(library_name: name)
          expect(configuration).to have_property(:use_default_library?, true)
        end
      end
    end

    context 'ライブラリ名がwork以外の場合' do
      it '偽を返す' do
        ['foo', 'wwork', 'workk', 'work_', 'wo_rk'].each do |name|
          configuration = create_configuration(library_name: name)
          expect(configuration).to have_property(:use_default_library?, false)
        end
      end
    end
  end

  describe 'エラーチェック' do
    context 'ライブラリ名が入力パターンに一致しない場合' do
      it 'ConfigurationErrorを起こす' do
        [
          '_',
          random_string(/_\w+/),
          random_string(/[a-z]/i),
          random_string(/[0-9][a-z_]/i),
          random_string(/[a-z_][[:punct:]&&[^_]][0-9a-z_]/i),
          random_string(/[a-z_]\s+[a-z_]/i)
        ].each do |invalid_name|
          expect { create_configuration(library_name: invalid_name) }
            .to raise_configuration_error("illegal input value for library name: #{invalid_name.inspect}")
        end
      end
    end
  end
end
