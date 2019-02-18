class NavigationItemMapper < Jekyll::Kentico::LinkedItemsMappers::Base
  def map
    @linked_items.map(&method(:map_item))
  end
private
  def map_item(item)
    elements = item.elements
    page_url = elements.page.value[0]
    subitems =  resolve_sub_items item

    {
      title: elements.title.value,
      url: page_url,
      subitems: subitems
    }
  end

  def resolve_sub_items(item)
    subitems = item.get_links 'subitems'
    return unless subitems.size > 0

    subitems.map(&method(:map_item))
  end
end