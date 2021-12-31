# frozen_string_literal: true

module RgGen
  module VHDL
    class Feature < SystemVerilog::Common::Feature
      include Utility

      private

      def create_signal(_, attributes, &block)
        DataObject.new(:signal, attributes, &block)
      end

      def create_port(direction, attributes, &block)
        attributes =
          attributes
            .merge(direction: { input: :in, output: :out }[direction])
        DataObject.new(:port, attributes, &block)
      end

      def create_generic(_, attributes, &block)
        DataObject.new(:generic, attributes, &block)
      end

      define_entity :signal, :create_signal, :signal, -> { component }
      define_entity :input, :create_port, :port, -> { register_block }
      define_entity :output, :create_port, :port, -> { register_block }
      define_entity :generic, :create_generic, :generic, -> { register_block }
    end
  end
end
