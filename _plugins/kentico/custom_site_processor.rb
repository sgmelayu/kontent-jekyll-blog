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
  LANGUAGES = ['en-US']

  def generate(site, kentico_data)
    @site = site
    @taxonomomy_groups = kentico_data.taxonomy_groups
    @items = kentico_data.items

    generate_authors_pages
    generate_posts_pages
    generate_tag_pages
    generate_categories_pages
  end

  private

  def generate_authors_pages
    LANGUAGES.each do |language|
      name = "authors-#{language}.html"
      data = {
        'title' => 'Authors',
        'layout' => 'default',
        'permalink' => "/#{language}/authors"
      }
      content = <<~CONTENT
        {% assign language = '#{language}' %}
        {% assign authors = site.authors | where_exp: 'author', 'author.item.system.language == language' %}
        
        <ul>
            {% for author in authors %}
                <li><a href="{{ author.url | relative_url }}">{{ author.item.elements.name.value }}</a></li>
            {% endfor %}
        </ul>
      CONTENT
      @site.pages << Page.new(@site, content, data, name)
    end
  end

  def generate_posts_pages
    LANGUAGES.each do |language|
      name = "posts-#{language}.html"
      data = {
        'title' => 'Posts',
        'layout' => 'default',
        'permalink' => "/#{language}/posts"
      }
      content = <<~CONTENT
        {% assign language = '#{language}' %}
        {% assign posts = site.posts | where_exp: 'post', 'post.item.system.language == language' %}
        
        <ul>
            {% for post in posts %}
                <li><a href="{{ post.url | relative_url }}">{{ post.item.elements.title.value }}</a></li>
            {% endfor %}
        </ul>
      CONTENT
      @site.pages << Page.new(@site, content, data, name)
    end
  end

  def get_tag_link(tag, language)
    <<~LINK
      {% assign tag = '#{tag.codename}' %}
      <li><a href="{{ '#{language}/tags/' | append: tag | relative_url }}">#{tag.name}</a></li>
    LINK
  end

  def generate_tag_pages
    tags = @taxonomomy_groups.find{ |tg| tg.system.codename == 'post_tags' }.terms

    LANGUAGES.each do |language|
      tags_name = "tags-#{language}.html"
      tags_data = {
        'title' => 'Tags',
        'layout' => 'default',
        'permalink' => "/#{language}/tags"
      }
      tags_content = <<~TAGS_CONTENT
        <ul>
        #{tags.map{ |tag| get_tag_link(tag, language) }.join("\n")}
        </ul>
      TAGS_CONTENT

      @site.pages << Page.new(@site, tags_content, tags_data, tags_name)

      tags.each do |tag|
        name = "#{tag.codename}-#{language}.html"
        dir = 'tags'
        data = {
          'title' => "#{tag.name}",
          'layout' => 'default',
          'permalink' => "#{language}/tags/#{tag.codename}"
        }
        content = <<~CONTENT
          {% assign language = '#{language}' %}
          {% assign tag = '#{tag.codename}' %}
          {% assign posts = site.posts | where_exp: 'post', 'post.item.system.language == language' %}
          {% assign tag_posts = posts | where_exp: 'post', 'post.tags contains tag' %}
          
          <ul>
              {% for post in tag_posts %}
                  <li><a href="{{ post.url | relative_url }}">{{ post.item.elements.title.value }}</a></li>
              {% endfor %}
          </ul>
        CONTENT
        @site.pages << Page.new(@site, content, data, name, dir: dir)
      end
    end
  end

  def get_category_link(category, language)
    <<~LINK
      {% assign category = '#{category.codename}' %}
      <li><a href="{{ '#{language}/categories/' | append: category | relative_url }}">#{category.name}</a></li>
    LINK
  end

  def generate_categories_pages
    categories = @taxonomomy_groups.find{ |tg| tg.system.codename == 'post_categories' }.terms

    LANGUAGES.each do |language|
      categories_name = "categories-#{language}.html"
      categories_data = {
        'title' => 'Categories',
        'layout' => 'default',
        'permalink' => "/#{language}/categories"
      }
      categories_content = <<~CATEGORIES_CONTENT
        <ul>
        #{categories.map{ |category| get_category_link(category, language) }.join("\n")}
        </ul>
      CATEGORIES_CONTENT

      @site.pages << Page.new(@site, categories_content, categories_data, categories_name)

      categories.each do |category|
        name = "#{category.codename}-#{language}.html"
        dir = 'categories'
        data = {
          'title' => "#{category.name}",
          'layout' => 'default',
          'permalink' => "#{language}/categories/#{category.codename}"
        }
        content = <<~CONTENT
          {% assign language = '#{language}' %}
          {% assign category = '#{category.codename}' %}
          {% assign posts = site.posts | where_exp: 'post', 'post.item.system.language == language' %}
          {% assign category_posts = posts | where_exp: 'post', 'post.categories contains category' %}
          
          <ul>
              {% for post in category_posts %}
                  <li><a href="{{ post.url | relative_url }}">{{ post.item.elements.title.value }}</a></li>
              {% endfor %}
          </ul>
        CONTENT
        @site.pages << Page.new(@site, content, data, name, dir: dir)
      end
    end
  end
end
