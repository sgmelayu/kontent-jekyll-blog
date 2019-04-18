module Jekyll
  module PrefixWithLanguageFilter
    def prefix_with_language(input, language)
      "#{language || default_language}#{input}"
    end

  private
    def default_language
      @context.registers[:site].config['kentico']['languages'].first
    end
  end
end

Liquid::Template.register_filter(Jekyll::PrefixWithLanguageFilter)
