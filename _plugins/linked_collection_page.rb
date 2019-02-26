module Jekyll
  module LinkedCollectionPage
    def linked_collection_page(linked_item, collection_name)
      collection = Jekyll.sites.first.data[collection_name]
      collection_items = collection&.select { |c| c['system']['codename'] == linked_item['codename'] }
      collection_items&.first
    end
  end
end

Liquid::Template.register_filter(Jekyll::LinkedCollectionPage)
