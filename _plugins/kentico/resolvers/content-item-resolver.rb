class ContentItemResolver < Jekyll::Kentico::Mappers::DataMapperFactory
  def execute
    case @item.system.type
    when 'city'
      {
        city_name: @item.elements.name.value,
        description: @item.elements.description.value,
        image_url: @item.elements.picture.value[0].url
      }
    else
      super
    end
  end
end
