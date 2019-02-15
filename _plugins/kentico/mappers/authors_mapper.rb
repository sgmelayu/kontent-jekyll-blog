class AuthorsMapper < Jekyll::Kentico::LinkedItemsMappers::Base
  def map
    @linked_items.map do |author|
      {
        id: author.system.id,
        name: author.elements.name.value,
      }
    end
  end
end