# frozen_string_literal: true

RgGen.define_simple_feature(:global, :library_name) do
  configuration do
    property :library_name, default: 'work'
    property :use_default_library?, body: -> { library_name.casecmp?('work') }

    input_pattern variable_name

    build do |value|
      pattern_matched? ||
        (error "illegal input value for library name: #{value.inspect}")
      @library_name = match_data.to_s
    end
  end
end
