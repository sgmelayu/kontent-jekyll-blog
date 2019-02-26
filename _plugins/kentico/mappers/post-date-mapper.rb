class PostDateMapper < Jekyll::Kentico::Mappers::DateMapperFactory
  def execute
    @item.elements.date.value
  end
end