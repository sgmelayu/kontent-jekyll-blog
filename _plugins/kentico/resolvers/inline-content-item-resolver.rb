class InlineContentItemResolver < Jekyll::Kentico::Resolvers::InlineContentItemResolver
  def resolve_content_item(item)
    type = item.system.type

    case type
    when 'author'
      resolve_author(item)
    else nil
    end
  end

private
  def resolve_author(author)
    "<h1>#{author.elements.name}</h1>"
  end
end