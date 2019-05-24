module Jekyll
  module WhereLinkedItemContainsFilter
    def where_linked_item_contains(pages, modular_element_codename, codename)
      pages.select do |page|
        page['item']['elements'][modular_element_codename]['value'].include? codename
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::WhereLinkedItemContainsFilter)
