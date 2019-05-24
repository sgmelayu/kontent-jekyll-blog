class ContentResolver
  def resolve(item)
    type = item.system.type

    case type
    when 'page' then resolve_page(item)
    when 'blog_post' then item.get_string('content')
    else nil
    end
  end

  private

  def get_post(post)
    <<~POST
      {% assign id = '#{post.system.id}' %}
      {% assign post = site.posts | where_exp: 'post', 'post.item.system.id == id' | first %}
      {% include post.html post=post.item %}
    POST
  end

  def get_author(author)
    <<~AUTHOR
      {% assign id = '#{author.system.id}' %}
      {% assign author = site.authors | where_exp: 'author', 'author.item.system.id == id' | first %}
      {% include authors_author.html author=author %}
    AUTHOR
  end

  def resolve_page(page)
    content = page.get_string('content')

    <<~PAGE
      <div class="page">
        #{content}
      </div>
    PAGE
  end

  def get_author_link(author)
    author_url = get_author_url author
    %(<a href="#{author_url}">#{author.elements.name.value}</a>)
  end

  def get_author_url(author)
    <<~URL
      {% assign author_id = '#{author.system.id}' %}
      {{ site.authors | where_exp: 'author', 'author.item.system.id == author_id' | map: 'url' | first | relative_url }}
    URL
  end

  def get_category_link(category, language)
    category_url = "{{ '#{language}/posts/categories/#{category.codename}' | relative_url }}"
    %(<a href="#{category_url}">#{category.name}</a>)
  end

  def get_tag_link(tag, language)
    tag_url = "{{ '#{language}/posts/tags/#{tag.codename}' | relative_url }}"
    %(<a href="#{tag_url}">#{tag.name}</a>)
  end

  def estimate_reading_time(input)
    words_per_minute = 300
    words = input.split.count
    minutes = (words.to_f / words_per_minute).ceil
    hours = minutes / 60
    leftover_minutes = minutes % 60

    if hours > 0 && leftover_minutes > 0
      "#{pluralize_with_count('hour', hours)} and #{pluralize_with_count('minute', leftover_minutes)}"
    elsif hours > 0
      pluralize_with_count('hour', hours)
    end

    pluralize_with_count('minute', leftover_minutes)
  end

  def pluralize_with_count(word, count)
    pluralized_word = count == 1 ? word : "#{word}s"
    "#{count}#{pluralized_word}"
  end
end
