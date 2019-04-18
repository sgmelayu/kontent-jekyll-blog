class ContentFrontMatterResolver
  def resolve(content_item, _content_type)
    @item = content_item

    {
      permalink: permalink,
      language: language,
      redirect_from: redirect_from
    }
  end

  private

  def redirect_from
    [''] if type == 'home' && language == 'en-US'
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
