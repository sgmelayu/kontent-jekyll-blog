class PageItemMapper < Jekyll::Kentico::Mappers::DataMapperFactory
  def execute
    elements = @item.elements

    {
      title: elements.title.value,
      taxonomies: elements.site.value.map(&:codename)
    }
  end
end