class Page < Jekyll::Page
  def initialize(site, content, data, name, dir: '')
    @site = site
    @base = site.source
    @dir = dir
    @name = name
    @path = if site.in_theme_dir(@base) == @base
              site.in_theme_dir(@base, @dir, @name)
            else
              site.in_source_dir(@base, @dir, @name)
            end

    self.process(@name)

    self.data = data
    self.content = content

    data.default_proc = proc do |_, key|
      site.frontmatter_defaults.find(File.join(@dir, @name), type, key)
    end

    Jekyll::Hooks.trigger :pages, :post_init, self
  end
end

class CustomSiteProcessor
  LANGUAGES = ['default']

  def generate(site, kentico_data)
    @site = site
    @taxonomomy_groups = kentico_data.taxonomy_groups
    @items = kentico_data.items

    generate_authors_pages
    generate_home_pages
    generate_tag_pages
    generate_categories_pages
  end

  private

  def generate_authors_pages
    LANGUAGES.each do |language|
      name = "authors-#{language}.html"
      data = {
        'title' => 'Authors',
        'layout' => 'authors',
        'permalink' => "/#{language}/authors",
        'language' => language
      }
      @site.pages << Page.new(@site, nil, data, name)
    end
  end

  def generate_home_pages
    LANGUAGES.each do |language|
      name = "home-#{language}.html"
      data = {
        'title' => 'Home',
        'layout' => 'home',
        'permalink' => "/#{language}/posts",
        'language' => language,
      }
      data['redirect_from'] = language == 'default' ? ['', '/', "/#{language}/"] : ["/#{language}/"]
      @site.pages << Page.new(@site, nil, data, name)
    end
  end

  def generate_tag_pages
    tags = @taxonomomy_groups.find{ |tg| tg.system.codename == 'post_tags' }.terms

    LANGUAGES.each do |language|
      tags_name = "tags-#{language}.html"
      tags_data = {
        'title' => 'Tags',
        'layout' => 'tags',
        'tags' => tags.map { |t| { 'codename' => t.codename, 'name' => t.name } },
        'language' => language,
        'permalink' => "/#{language}/posts/tags"
      }
      tags_dir = 'posts'

      @site.pages << Page.new(@site, nil, tags_data, tags_name, dir: tags_dir)

      tags.each do |tag|
        name = "#{tag.codename}-#{language}.html"
        dir = 'posts/tags'
        data = {
          'title' => "#{tag.name}",
          'layout' => 'tag',
          'tag' => { 'codename' => tag.codename, 'name' => tag.name },
          'language' => language,
          'permalink' => "#{language}/posts/tags/#{tag.codename}"
        }
        @site.pages << Page.new(@site, nil, data, name, dir: dir)
      end
    end
  end

  def generate_categories_pages
    categories = @taxonomomy_groups.find{ |tg| tg.system.codename == 'post_categories' }.terms

    LANGUAGES.each do |language|
      categories_name = "categories-#{language}.html"
      categories_data = {
        'title' => 'Categories',
        'layout' => 'categories',
        'language' => language,
        'categories' => categories.map { |c| { 'codename' => c.codename, 'name' => c.name } },
        'permalink' => "/#{language}/posts/categories"
      }
      categories_dir = 'posts'

      @site.pages << Page.new(@site, nil, categories_data, categories_name, dir: categories_dir)

      categories.each do |category|
        name = "#{category.codename}-#{language}.html"
        dir = 'posts/categories'
        data = {
          'title' => "#{category.name}",
          'layout' => 'category',
          'language' => language,
          'category' => { 'codename' => category.codename, 'name' => category.name },
          'permalink' => "#{language}/posts/categories/#{category.codename}"
        }
        @site.pages << Page.new(@site, nil, data, name, dir: dir)
      end
    end
  end
end
