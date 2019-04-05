class ContentItemResolver < Jekyll::Kentico::Resolvers::ContentItemResolver
  def resolve_item(item)
    case item.system.type
    when 'city'
      {
        city_name: item.elements.name.value,
        description: item.elements.description.value,
        image_url: item.elements.picture.value[0].url
      }
    else
      super
    end
  end
end
