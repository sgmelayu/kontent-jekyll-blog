require 'date'

module Jekyll
  module PostLinkFilter
    def get_post_link(post)
      date = Date.parse(post['elements']['date']).strftime "%Y/%m/%d"
      title = post['system']['codename']
      "#{date}/#{title}.html"
    end
  end
end

Liquid::Template.register_filter(Jekyll::PostLinkFilter)
