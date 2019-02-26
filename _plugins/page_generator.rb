module Jekyll
  class MyPageGenerator < Generator
    safe true

    def generate(site)
      #site.pages << MyPage.new(site, site.source,'/', 'lolo.html')
    end
  end

  class MyPage < Page
    def initialize(site, base, dir, name)
      self.process(@name)
      self.read_yaml(File.join(site.source, '_layouts'), 'page.html')
      self.data['category'] = 'category'
      self.render_liquid
      category_title_prefix = site.config['category_title_prefix'] || 'Category: '
      self.data['title'] = "#{category_title_prefix}#{'dsa'}"
      #
      self.content = ':P:'
    end
  end
end