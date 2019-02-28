module Jekyll
  module PagesForTaxonomyTermsFilter
    def page_for_taxonomy_term(pages, term)
      pages.find do |page|
        elements = page.data['elements']
        site = elements && elements['site']
        page_terms = site && site.map { |page_term| page_term['codename'] }
        page_terms&.include? term['codename']
      end
    end
  end
end

Liquid::Template.register_filter Jekyll::PagesForTaxonomyTermsFilter
