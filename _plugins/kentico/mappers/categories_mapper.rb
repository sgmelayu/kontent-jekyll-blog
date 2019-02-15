class CategoriesMapper < Jekyll::Kentico::LinkedItemsMappers::Base
  def map
    @linked_items.map do |category|
      {
        id: category.system.id,
        name: category.elements.name.value,
      }
    end
  end
end