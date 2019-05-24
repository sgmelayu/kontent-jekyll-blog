module Jekyll
  module StringifyDateFilter
    def stringify_date(date, format = '%b %d, %Y')
      Date.parse(date).strftime(format)
    end
  end
end

Liquid::Template.register_filter(Jekyll::StringifyDateFilter)
