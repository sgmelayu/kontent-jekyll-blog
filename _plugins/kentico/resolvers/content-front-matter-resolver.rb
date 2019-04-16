class ContentFrontMatterResolver
  def resolve(content_item, content_type)
    @item = content_item

    {
      'permalink' => permalink,
      'language' => language,
      'redirect_from' => redirect_from
    }
  end

  def redirect_from
    [''] if @item.system.type == 'home' && @item.system.language == 'en-US'
  end

  def language
    @item.system.language
  end

  def permalink
    language_base = "/#{@item.system.language}"
    sitemap = @item.elements.sitemap.value.first&.codename
    slug = @item.elements.slug.value

    return "#{language_base}" if @item.system.type == 'home'
    return "#{language_base}/#{sitemap}/#{slug}" if sitemap
    "#{language_base}/#{slug}"
  end
end
