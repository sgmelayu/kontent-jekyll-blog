class FrontMatterResolver
  def resolve(content_item, _page_type)
    @item = content_item

    extra_data = get_extra_data

    data = {
      permalink: permalink,
      language: language
    }

    data.merge!(extra_data) if extra_data
    data
  end

  private

  def get_extra_data
  end

  def type
    @item.system.type
  end

  def language
    @item.system.language
  end

  def permalink
    language_base = "/#{language}"
    category = @item.elements.site_content.value.first&.codename
    slug = @item.elements.slug.value

    return "#{language_base}/#{category}/#{slug}" if category

    "#{language_base}/#{slug}"
  end
end