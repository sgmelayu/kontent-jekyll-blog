module Jekyll
  module ShouldBeHighlightedFilter
    def should_be_highlighted(current_url, nav_url)
      current_url = current_url[1..-1]
      return current_url == nav_url if /^([^\/]*)$/.match? nav_url

      current_url.include? nav_url
    end
  end
end

Liquid::Template.register_filter(Jekyll::ShouldBeHighlightedFilter)
