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
    id = post.system.id
    elements = post.elements

    title = elements.title.value
    authors = post.get_links('authors').map { |author| author.elements.name.value }.take(2).join(", ")
    categories = elements.post_categories.value.map(&:name).take(2).join(", ")
    date = elements.published.value
    thumbnail_url = elements.thumbnail.value[0].url
    post_url = <<~URL
      {% assign post_id = '#{id}' %}
      {{ site.posts | where_exp: 'post', 'post.item.system.id == post_id' | map: 'url' | first | relative_url }}"
    URL

    <<~EOF
      <div class="home__author">
        <a href="#{post_url}"><img src="#{thumbnail_url}"/></a>
        <a href="#{post_url}"><label>#{title}</label></a>
        <div class="home__post-date">#{stringify_date date}</div>
        <div class="home__post-authors">#{authors}</div>
        <div class="home__post-categories">#{categories}</div>
      </div>
    EOF
  end

  def get_author(author)
    elements = author.elements

    name = elements.name.value
    location = elements.location.value
    birthdate = stringify_date elements.date_of_birth.value
    avatar_url = elements.avatar.value[0].url
    author_url = get_author_url author

    <<~EOF
      <div class="home__author">
        <a href="#{author_url}"><img src="#{avatar_url}"/></a>
        <a href="#{author_url}"><label>#{name}</label></a>
        <div class="home__avatar-date">#{birthdate}</div>
        <div class="home__avatar-location">#{location}</div>
        <div class="home__avatar-posts"></div>
      </div>
    EOF
  end

  def resolve_home(home)
    posts = home.get_links 'posts'
    authors = home.get_links 'authors'

    <<~EOF
      <div class="home">
        <h1>Welcome on the home page</h1>

        <h2>Posts</h2>
        <div class="home-posts">
          #{posts.map(&method(:get_post)).join("\n")}
        </div>

        <h2>Authors</h2>
        <div class="home-authors">
          #{authors.map(&method(:get_author)).join("\n")}
        </div>
      </div>
    EOF
  end

  def resolve_page(page)
    if page.system.codename == 'authors_page'
      return <<~EOF
        #{page.get_string 'content'}
        {% assign language = page.item.system.language %}
        {% assign authors_for_this_language = site.authors | where_exp: 'author', 'author.item.system.language == language' %}
        {% assign ids = "" %}
        {% assign delimiter = "," %}

        <ul>
          {% for author in authors_for_this_language %}
            <li>
                  <h2>
                      <a href="{{ author.url | relative_url }}">
                          {{ author.item.elements.name.value }}
                      </a>
                  </h2>
              </li>
          {% endfor %}
        </ul>
      EOF
    end

    <<~EOF
      <div class="page">
        <h1>#{page.elements.title.value}</h1>

        #{page.get_string 'content'}
      </div>
    EOF
  end

  def resolve_author(author)
    elements = author.elements

    <<~EOF
      <div class="author">
        <p>Name: #{elements.name.value}</p>
        <img src="#{elements.avatar.value[0].url}" />
        <p>Location: #{elements.location.value}</p>
        <p>Birthdate: #{stringify_date elements.date_of_birth.value}</p>
        <div>#{author.get_string 'biography'}</div>
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
    EOF
  end

  def get_author_link(author)
    author_url = get_author_url author
    %{<a href="#{author_url}">#{author.elements.name.value}</a>}
  end

  def get_author_url(author)
    <<~EOF
      {% assign author_id = '#{author.system.id}' %}
      {{ site.authors | where_exp: 'author', 'author.item.system.id == author_id' | map: 'url' | first | relative_url }}
    EOF
  end

  def get_category_link(category, language)
    category_url = "{{ '#{language}/posts/categories/#{category.codename}' | relative_url }}"
    %{<a href="#{category_url}">#{category.name}</a>}
  end

  def get_tag_link(tag, language)
    tag_url = "{{ '#{language}/posts/tags/#{tag.codename}' | relative_url }}"
    %{<a href="#{tag_url}">#{tag.name}</a>}
  end

  def resolve_post(post)
    elements = post.elements
    language = post.system.language
    authors = post.get_links('authors').map(&method(:get_author_link)).join("\n")
    categories = elements.post_categories.value.map{ |category| get_category_link(category, language) }.join("\n")
    tags = elements.post_tags.value.map{ |tag| get_tag_link(tag, language) }.join("\n")

    <<~EOF
      <div class="post-navigation">
        {% if page.previous.url %}
            <a class="prev" href="{{ page.previous.url | relative_url }}">&laquo; {{page.previous.title}}</a>
        {% endif %}
        {% if page.next.url %}
            <a class="next" href="{{ page.next.url | relative_url }}">{{page.next.title}} &raquo;</a>
        {% endif %}
      </div>

      #{Date.parse(elements.published.value).strftime("%a, %b %d, %Y")}
      <p>Estimated reading time: #{estimate_reading_time(post.get_string 'content')}</p>
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

      #{post.get_string('content')}
    EOF
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
