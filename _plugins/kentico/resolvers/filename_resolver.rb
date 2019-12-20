class FilenameResolver
  def resolve(item)
    url_slug = get_url_slug(item)
    "#{url_slug.value}-#{item.system.language}"
  end

  private

  def get_url_slug(item)
    item.elements.each_pair { |_codename, element| return element if slug?(element) }
  end

  def slug?(element)
    element.type == Kentico::Kontent::Constants::ItemElementType::URL_SLUG
  end
end
