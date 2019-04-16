class ContentItemFilenameResolver
  def resolve_filename(item)
    url_slug = get_url_slug(item)
    "#{url_slug.value}-#{item.system.language}"
  end

private
  def get_url_slug(item)
    item.elements.each_pair { |codename, element| return element if element.type == Jekyll::Kentico::Constants::ItemElement::URL_SLUG }
  end
end
