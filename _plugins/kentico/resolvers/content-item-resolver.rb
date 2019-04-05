class ContentItemResolver < Jekyll::Kentico::Resolvers::ContentItemResolver
  alias_method :resolve_item_base, :resolve_item

  def initialize
    @depth = 0
  end

  def resolve_item(item)
    resolve_item_internal(item, 0)
  end

  def resolve_element(params)
    element = params.element

    case element.type
    when Jekyll::Kentico::Constants::ItemElement::ASSET
      element.value.map { |asset| asset['url'] }
    when Jekyll::Kentico::Constants::ItemElement::RICH_TEXT
      params.get_string.call(element)
    when Jekyll::Kentico::Constants::ItemElement::LINKED_ITEMS
      return [] if @depth > 4

      params.get_links.call(element).map { |linked_item| resolve_item_internal(linked_item, @depth + 1) }
    else
      element.value
    end
  end

private
  def resolve_item_internal(item, depth)
    @depth = depth
    case item.system.type
    when 'city'
      {
        city_name: item.elements.name.value,
        description: item.elements.description.value,
        image_url: item.elements.picture.value[0].url
      }
    else
      resolve_item_base(item)
    end
  end
end
