class DataBlogPostAuthorMapper < Jekyll::Kentico::LinkedItemsMappers::Base
  def map
    @linked_items.map do |author|
      {
        id: author.system.id,
        elements: author.elements
      }
    end
  end
end