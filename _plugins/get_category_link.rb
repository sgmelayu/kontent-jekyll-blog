module Jekyll
  module CategoryLinkFilter
    def get_category_link(input)
      "/categories/#{input}.html"
    end
  end
end

Liquid::Template.register_filter(Jekyll::CategoryLinkFilter)
