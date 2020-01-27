def except(items, item)
  items.select { |x| x.codename != item.codename }
end

class Page < Jekyll::Page
  def initialize(site, data, name, dir = '', content = nil)
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
  include Kentico::Kontent::Utils

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

  def languages
    @languages ||= @site.config['kentico']['languages']
  end

  def generate_authors_pages
    languages.each do |language|
      name = "authors-#{language}.html"
      data = {
        'title' => 'Authors',
        'layout' => 'authors',
        'permalink' => "/#{language}/authors",
        'language' => language
      }
      @site.pages << Page.new(@site, data, name)
    end
  end

  def generate_home_pages
    languages.each do |language|
      name = "home-#{language}.html"
      data = {
        'title' => 'Home',
        'layout' => 'home',
        'permalink' => "/#{language}/posts",
        'language' => language,
      }
      data['redirect_from'] = language == languages[0] ? ['', '/', "/#{language}/"] : ["/#{language}/"]
      @site.pages << Page.new(@site, data, name)
    end
  end

  def generate_tag_pages
    taxonomy_group = @taxonomomy_groups.find{ |tg| tg.system.codename == 'post_tags' }

    languages.each do |language|
      tags_name = "tags-#{language}.html"
      tags_data = {
        'title' => 'Tags',
        'layout' => 'tags',
        'taxonomy_group' => normalize_object({
          system: taxonomy_group.system,
          terms: taxonomy_group.terms
        }),
        'language' => language,
        'permalink' => "/#{language}/tags"
      }

      @site.pages << Page.new(@site, tags_data, tags_name)

      taxonomy_group.terms.each do |tag|
        name = "#{tag.codename}-#{language}.html"
        dir = 'tags'
        data = {
          'title' => "#{tag.name}",
          'layout' => 'tag',
          'tag' => normalize_object(tag),
          'other_tags' => normalize_object(except(taxonomy_group.terms, tag)),
          'language' => language,
          'permalink' => "#{language}/tags/#{tag.codename}"
        }
        @site.pages << Page.new(@site, data, name, dir)
      end
    end
  end

  def generate_categories_pages
    taxonomy_group = @taxonomomy_groups.find{ |tg| tg.system.codename == 'post_categories' }

    languages.each do |language|
      categories_name = "categories-#{language}.html"
      categories_data = {
        'title' => 'Categories',
        'layout' => 'categories',
        'taxonomy_group' => normalize_object({
          system: taxonomy_group.system,
          terms: taxonomy_group.terms
        }),
        'language' => language,
        'permalink' => "/#{language}/categories"
      }

      @site.pages << Page.new(@site, categories_data, categories_name)

      taxonomy_group.terms.each do |category|
        name = "#{category.codename}-#{language}.html"
        dir = 'categories'
        data = {
          'title' => "#{category.name}",
          'layout' => 'category',
          'language' => language,
          'category' => normalize_object(category),
          'other_categories' => normalize_object(except(taxonomy_group.terms, category)),
          'permalink' => "#{language}/categories/#{category.codename}"
        }
        @site.pages << Page.new(@site, data, name, dir)
      end
    end
  end
end
