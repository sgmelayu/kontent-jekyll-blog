module Jekyll
  module FilterByLanguageFilter
    def filter_by_language(pages, language)
      pages.select { |page| page['item']['system']['language'] == language }
    end
  end
end

Liquid::Template.register_filter(Jekyll::FilterByLanguageFilter)
