class DataResolver
  def initialize
    @depth = 0
  end

  def resolve(item)
    resolve_internal(item, 0)
  end

private
  def resolve_internal(item, depth)
    @depth = depth

    OpenStruct.new(
      system: item.system,
      elements: process_elements(item)
    )
  end

  def process_elements(item)
    mapped_elements = OpenStruct.new

    item.elements.each_pair do |codename, element|
      resolved_element = resolve_element(element, codename, item)
      mapped_elements[codename] = resolved_element
    end

    mapped_elements
  end

  def resolve_element(element, codename, item)
    case element.type
    when Jekyll::Kentico::Constants::ItemElementType::ASSET
      element.value.map { |asset| asset['url'] }
    when Jekyll::Kentico::Constants::ItemElementType::RICH_TEXT
      item.get_string codename.to_s
    when Jekyll::Kentico::Constants::ItemElementType::LINKED_ITEMS
      return [] if @depth > 4

      item.get_links(codename.to_s).map { |linked_item| resolve_internal(linked_item, @depth + 1) }
    else
      element.value
    end
  end
end
