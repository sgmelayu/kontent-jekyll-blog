class AuthorsMapper < Jekyll::Kentico::Mappers::LinkedItemsMapperFactory
  def execute
    @linked_items.map do |author|
      {
        codename: author.system.codename,
        name: author.elements.name.value,
      }
    end
  end
end