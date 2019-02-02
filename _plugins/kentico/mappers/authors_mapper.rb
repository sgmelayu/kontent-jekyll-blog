class AuthorsMapper < Jekyll::Kentico::LinkedItemsMappers::Base
  def map
    @linked_items.select { |codename| @linked_codenames.include? codename }.values.map do |author|
      sys = author['system']
      id = sys['id']
      elements = author['elements']
      name = elements['name']['value']

      {
        'id' => id,
        'name' => name,
      }
    end
  end
end