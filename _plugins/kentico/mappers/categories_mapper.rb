class CategoriesMapper < Jekyll::Kentico::LinkedItemsMappers::Base
  def map
    @linked_items.select { |codename| @linked_codenames.include? codename }.values.map do |category|
      sys = category['system']
      id = sys['id']
      elements = category['elements']
      name = elements['name']['value']

      {
        'id' => id,
        'name' => name,
      }
    end
  end
end