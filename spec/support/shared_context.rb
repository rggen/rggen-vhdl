# frozen_string_literal: true

RSpec.shared_context 'vhdl common' do
  include_context 'configuration common'
  include_context 'register map common'

  def build_vhdl_factory(builder)
    builder.build_factory(:output, :vhdl)
  end

  def create_vhdl(configuration = nil, &data_block)
    register_map = create_register_map(configuration) do
      register_block(&data_block)
    end
    @vhdl_factory[0] ||= build_vhdl_factory(RgGen.builder)
    @vhdl_factory[0].create(configuration || default_configuration, register_map)
  end

  def delete_vhdl_factory
    @vhdl_factory.clear
  end

  def have_generic(*args, &body)
    layer, handler, attributes =
      case args.size
      when 3 then args[0..2]
      when 2 then [nil, *args[0..1]]
      else [nil, args[0], {}]
      end
    attributes = { name: handler }.merge(attributes)
    generic = RgGen::VHDL::Utility::DataObject.new(:generic, **attributes, &body)
    have_declaration(layer, :generic, generic.declaration).and have_identifier(handler, generic.identifier)
  end

  def have_port(*args, &body)
    layer, handler, attributes =
      case args.size
      when 3 then args[0..2]
      when 2 then [nil, *args[0..1]]
      else [nil, args[0], {}]
      end
    attributes = { name: handler }.merge(attributes)
    port = RgGen::VHDL::Utility::DataObject.new(:port, **attributes, &body)
    have_declaration(layer, :port, port.declaration).and have_identifier(handler, port.identifier)
  end

  def not_have_port(*args, &body)
    layer, handler, attributes =
      case args.size
      when 3 then args[0..2]
      when 2 then [nil, *args[0..1]]
      else [nil, args[0], {}]
      end
    attributes = { name: handler }.merge(attributes)
    port = RgGen::VHDL::Utility::DataObject.new(:port, **attributes, &body)
    not_have_declaration(layer, :port, port.declaration).and not_have_identifier(handler, port.identifier)
  end

  def have_signal(*args, &body)
    layer, handler, attributes =
      case args.size
      when 3 then args[0..2]
      when 2 then [nil, *args[0..1]]
      else [nil, args[0], {}]
      end
    attributes = { name: handler }.merge(attributes)
    signal = RgGen::VHDL::Utility::DataObject.new(:signal, **attributes, &body)
    have_declaration(layer, :signal, signal.declaration).and have_identifier(handler, signal.identifier)
  end

  def not_have_signal(*args, &body)
    layer, handler, attributes =
      case args.size
      when 3 then args[0..2]
      when 2 then [nil, *args[0..1]]
      else [nil, args[0], {}]
      end
    attributes = { name: handler }.merge(attributes)
    signal = RgGen::VHDL::Utility::DataObject.new(:signal, **attributes, &body)
    not_have_declaration(layer, :signal, signal.declaration).and not_have_identifier(handler, signal.identifier)
  end

  before(:all) do
    @vhdl_factory ||= []
  end
end

RSpec.shared_context 'bit field vhdl common' do
  include_context 'vhdl common'

  before(:all) do
    RgGen.enable(:global, [:address_width, :enable_wide_register, :library_name])
    RgGen.enable(:register_block, [:byte_size, :bus_width])
    RgGen.enable(:register_file, [:name, :size, :offset_address])
    RgGen.enable(:register, [:name, :size, :type, :offset_address])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :initial_value, :reference, :type])
    RgGen.enable(:register_block, :vhdl_top)
    RgGen.enable(:register_file, :vhdl_top)
    RgGen.enable(:register, :vhdl_top)
    RgGen.enable(:bit_field, :vhdl_top)
  end

  let(:library_name) do
    ['work', 'foo_lib'].sample
  end

  def create_bit_fields(&body)
    configuration =
      create_configuration(enable_wide_register: true, library_name: library_name)
    create_vhdl(configuration, &body).bit_fields
  end
end
