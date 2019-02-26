class NavigationItemMapper < Jekyll::Kentico::Mappers::LinkedItemsMapperFactory
  def execute
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
    subitems.map(&method(:map_item)) if subitems.size > 0
  end
end