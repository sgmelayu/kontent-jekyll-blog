module Jekyll
  module LinkedCollectionPage
    def linked_collection_page(codename, collection_name)
      collection = Jekyll.sites.first.collections[collection_name]
      collection_items = collection&.docs&.select { |c| c['system']['codename'] == codename }
      collection_items&.first
    end
  end
end

Liquid::Template.register_filter(Jekyll::LinkedCollectionPage)
