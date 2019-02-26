module Jekyll
  module PagesForTaxonomyTermsFilter
    def page_for_taxonomy_term(pages, term)
      pages.find { |page| page.data['taxonomies']&.include? term['codename'] }
    end
  end
end

Liquid::Template.register_filter Jekyll::PagesForTaxonomyTermsFilter
