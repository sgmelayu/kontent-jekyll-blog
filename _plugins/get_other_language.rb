module Jekyll
  module GetOtherLanguageFilter
    def get_other_language(language)
      return unless language

      languages = @context.registers[:site].config['kentico']['languages']
      (languages - [language]).first
    end
  end
end

Liquid::Template.register_filter(Jekyll::GetOtherLanguageFilter)
