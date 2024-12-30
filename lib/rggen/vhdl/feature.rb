# frozen_string_literal: true

module RgGen
  module VHDL
    class Feature < SystemVerilog::Common::Feature
      include Utility

      private

      def create_signal(_, attributes, &)
        DataObject.new(:signal, attributes, &)
      end

      def create_port(direction, attributes, &)
        attributes =
          attributes
            .merge(direction: { input: :in, output: :out }[direction])
        DataObject.new(:port, attributes, &)
      end

      def create_generic(_, attributes, &)
        DataObject.new(:generic, attributes, &)
      end

      define_entity :signal, :create_signal, :signal, -> { component }
      define_entity :input, :create_port, :port, -> { register_block }
      define_entity :output, :create_port, :port, -> { register_block }
      define_entity :generic, :create_generic, :generic, -> { register_block }
    end
  end
end
