class ContentResolver
  def resolve(item)
    type = item.system.type

    case type
    when 'home' then resolve_home(item)
    when 'page' then resolve_page(item)
    when 'author' then resolve_author(item)
    when 'blog_post' then resolve_post(item)
    else 'Content is missing'
    end
  end

  private

  def get_post(post)
    <<~POST
      {% assign id = '#{post.system.id}' %}
      {% assign post = site.posts | where_exp: 'post', 'post.item.system.id == id' | first %}
      {% include post.html post=post %}
    POST
  end

  def get_author(author)
    <<~AUTHOR
      {% assign id = '#{author.system.id}' %}
      {% assign author = site.authors | where_exp: 'author', 'author.item.system.id == id' | first %}
      {% include author.html author=author %}
    AUTHOR
  end

  def resolve_home(home)
    posts = home.get_links 'posts'
    authors = home.get_links 'authors'

    <<~HOME
      <div class="home">
        <h2>Posts</h2>
        <div class="home-posts">
          #{posts.map(&method(:get_post)).join("\n")}
        </div>

        <h2>Authors</h2>
        <div class="home-authors">
          #{authors.map(&method(:get_author)).join("\n")}
        </div>
      </div>
    HOME
  end

  def resolve_page(page)
    content = page.get_string('content')

    <<~PAGE
      <div class="page">
        #{content}
      </div>
    PAGE
  end

  def resolve_author(author)
    elements = author.elements

    <<~AUTHOR
      <div class="author">
        <p>Name: #{elements.name.value}</p>
        <img src="#{elements.avatar.value[0].url}" />
        <p>Location: #{elements.location.value}</p>
        <p>Birthdate: #{stringify_date elements.date_of_birth.value}</p>
        <div>#{author.get_string('about')}</div>
      </div>

      <h3>Posts</h3>

      <ul>
      {% for post in site.posts %}
          {% if post.item.elements.authors.value contains page.item.system.codename %}
              {% if post.item.system.language == page.item.system.language %}
                  <li><a href="{{ post.url | relative_url }}">{{ post.item.elements.title.value }}</a></li>
              {% endif %}
          {% endif %}
      {% endfor %}
      </ul>
    AUTHOR
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

  def resolve_post(post)
    elements = post.elements
    language = post.system.language
    authors = post.get_links('authors').map(&method(:get_author_link)).join("\n")
    categories = elements.post_categories.value.map{ |category| get_category_link(category, language) }.join("\n")
    tags = elements.post_tags.value.map{ |tag| get_tag_link(tag, language) }.join("\n")
    published_date = Date.parse(elements.published.value).strftime("%a, %b %d, %Y")
    content = post.get_string('content')
    reading_time = estimate_reading_time(content)

    <<~POST
      <div class="post-navigation">
        {% if page.previous.url %}
            <a class="prev" href="{{ page.previous.url | relative_url }}">&laquo; {{page.previous.title}}</a>
        {% endif %}
        {% if page.next.url %}
            <a class="next" href="{{ page.next.url | relative_url }}">{{page.next.title}} &raquo;</a>
        {% endif %}
      </div>

      <div class="post">
        #{published_date}
        <p>Estimated reading time: #{reading_time}</p>
        <p>
            Authors:
            #{authors}
        </p>
        <p>
            Categories:
            #{categories}
        </p>
        <p>
            Tags:
            #{tags}
        </p>
      </div>

      #{content}
    POST
  end

  def stringify_date(date_value)
    Date.parse(date_value).strftime("%a, %b %d, %Y")
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
