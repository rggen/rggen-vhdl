# frozen_string_literal: true

module RgGen
  module VHDL
    module Utility
      class DataObject
        include Core::Utility::AttributeSetter

        def initialize(object_type, default_attributes = {})
          @object_type = object_type
          apply_attributes(**default_attributes)
          block_given? && yield(self)
        end

        define_attribute :name
        define_attribute :direction
        define_attribute :type
        define_attribute :width
        define_attribute :array_size
        define_attribute :default

        def declaration
          declaration_snippets
            .compact
            .reject(&:empty?)
            .join(' ')
        end

        def identifier
          Identifier.new(name) do |identifier|
            identifier.__width__(width)
            identifier.__array_size__(array_size)
          end
        end

        private

        def declaration_snippets
          [
            object_type_keyword,
            "#{name}:",
            direction_keyword,
            type_declaration,
            default_value
          ]
        end

        def object_type_keyword
          [:signal].include?(@object_type) && @object_type || nil
        end

        def direction_keyword
          @object_type == :port && direction || nil
        end

        def type_declaration
          if @object_type == :generic && type
            type
          else
            msb = calc_msb
            msb && "#{default_vector_type}(#{msb} downto 0)" || default_type
          end
        end

        def calc_msb
          width = calc_actual_width
          width && (width.is_a?(Integer) && width - 1 || "#{width}-1")
        end

        def calc_actual_width
          return width if array_size.nil? || array_size.empty?
          size = [width, *array_size].compact
          size.all? { |s| s.is_a?(Integer) } && size.inject(:*) || size.join('*')
        end

        def default_vector_type
          @object_type == :generic && 'unsigned' || 'std_logic_vector'
        end

        def default_type
          @object_type == :generic && 'unsigned' || 'std_logic'
        end

        def default_value
          return nil if @object_type != :generic || default.nil?
          ":= #{default}"
        end
      end
    end
  end
end
