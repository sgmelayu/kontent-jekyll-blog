class DataBlogPostAuthorMapper < Jekyll::Kentico::Mappers::LinkedItemsMapperFactory
  def execute
    @linked_items.map do |author|
      {
        id: author.system.id,
        elements: author.elements
      }
    end
  end
end