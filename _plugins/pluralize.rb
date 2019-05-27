module Jekyll
  module PluralizeFilter
    def pluralize(input, count)
      pluralized_word = count == 1 ? input : "#{input}s"
      "#{count} #{pluralized_word}"
    end
  end
end

Liquid::Template.register_filter(Jekyll::PluralizeFilter)