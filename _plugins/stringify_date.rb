module Jekyll
  module StringifyDateFilter
    def stringify_date(date)
      Date.parse(date).strftime('%a, %b %d, %Y')
    end
  end
end

Liquid::Template.register_filter(Jekyll::StringifyDateFilter)
