class CategoriesMapper < Jekyll::Kentico::Mappers::LinkedItemsMapperFactory
  def execute
    @linked_items.map do |category|
      {
        codename: category.system.codename,
        name: category.elements.name.value,
      }
    end
  end
end