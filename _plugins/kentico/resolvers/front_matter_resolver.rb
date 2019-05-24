class FrontMatterResolver
  def resolve(content_item, _page_type)
    @item = content_item

    extra_data = get_extra_data

    data = {
      permalink: permalink,
      language: language,
      redirect_from: redirect_from
    }

    data.merge!(extra_data) if extra_data
    data
  end

  private

  def get_extra_data
    case type
    when 'home' then { authors: home_authors, posts: home_posts }
    end
  end

  def home_authors
    @item.get_links('authors').map(&:to_h)
  end

  def home_posts
    @item.get_links('posts').map(&:to_h)
  end

  def redirect_from
    [''] if type == 'home' && language == 'default'
  end

  def type
    @item.system.type
  end

  def language
    @item.system.language
  end

  def permalink
    language_base = "/#{language}"
    sitemap = @item.elements.sitemap.value.first&.codename
    slug = @item.elements.slug.value

    return language_base if type == 'home'
    return "#{language_base}/#{sitemap}/#{slug}" if sitemap

    "#{language_base}/#{slug}"
  end
end
