module Jekyll
  module AuthorLinkFilter
    def get_author_link(input)
      "/authors/#{input}.html"
    end
  end
end

Liquid::Template.register_filter(Jekyll::AuthorLinkFilter)