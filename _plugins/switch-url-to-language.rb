module SwitchUrlToLanguageFilter
  def switch_url_to_language(input, language)
    input.sub %r{^/([^/]*)}, language
  end
end

Liquid::Template.register_filter(SwitchUrlToLanguageFilter)
