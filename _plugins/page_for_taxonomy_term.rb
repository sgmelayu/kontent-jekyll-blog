module Jekyll
  module PagesForTaxonomyTermsFilter
    def page_for_taxonomy_term(pages, term)
      pages.find do |page|
        codes = page.data['elements']['site'].map { |sitemap| sitemap['codename'] }
        codes.include? term['codename']
      end
    end
  end
end

Liquid::Template.register_filter Jekyll::PagesForTaxonomyTermsFilter
