class InlineContentItemResolver < Kentico::Kontent::Delivery::Resolvers::InlineContentItemResolver
  def resolve_item(item)
    type = item.system.type

    case type
    when 'author'
      resolve_author item
    else
      ''
    end
  end

  private

  def resolve_author(author)
    elements = author.elements
    "#{elements.name.value} @ #{elements.location.value}"
  end
end
