class PageContentMapper < Jekyll::Kentico::Mappers::ContentMapperFactory
  def execute
    @item.elements.content.value
  end
end