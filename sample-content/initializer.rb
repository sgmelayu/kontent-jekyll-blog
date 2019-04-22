require 'digest'
require 'http'
require 'open-uri'
require 'jekyll-kentico/constants/item_element_type'
require_relative 'creator'
require_relative 'constants'

module SampleContent
  module Initializer
    include Jekyll::Kentico::Constants
    include SampleContent::Constants
    extend self

    def initialize_sample_content
      create_taxonomies
      create_types
      create_items
    end

    private

    def creator
      @creator ||= Creator.new(ENV['PROJECT_ID'], ENV['CM_API_KEY'])
    end

    def get_tag(name)
      { name: name, terms: [] }
    end

    def create_taxonomies
      sitemap = {
        name: 'Sitemap',
        terms: [
          { name: 'Home', terms: [] },
          { name: 'Posts', terms: [] },
          { name: 'Authors', terms: [] },
          { name: 'About us', terms: [] }
        ]
      }

      post_tags = {
        name: 'Post tags',
        terms: [
          get_tag('Lorem'),
          get_tag('Elitr'),
          get_tag('Diam'),
          get_tag('Eos'),
          get_tag('Consequat')
        ]
      }

      post_categories = {
        name: 'Post categories',
        terms: [
          get_tag('Facilisi delenit'),
          get_tag('Sed amet'),
          get_tag('Magna et')
        ]
      }

      @sitemap_taxonomy = creator.create_taxonomy(sitemap)
      @post_tags_taxonomy = creator.create_taxonomy(post_tags)
      @post_categories_taxonomy = creator.create_taxonomy(post_categories)
    end

    def create_types
      page_title_external_id = 'page_title'
      home_title_external_id = 'home_title'
      author_name_external_id = 'author_name'
      post_title_external_id = 'post_title'

      page = {
        name: 'Page',
        elements: [
          {
            name: 'Title',
            type: ItemElementType::TEXT,
            external_id: page_title_external_id
          },
          {
            name: 'Slug',
            type: ItemElementType::URL_SLUG,
            depends_on: {
              element: { external_id: page_title_external_id }
            }
          },
          {
            name: 'Content',
            type: ItemElementType::RICH_TEXT
          },
          {
            type: ItemElementType::TAXONOMY,
            taxonomy_group: {
              codename: @sitemap_taxonomy.codename
            }
          }
        ]
      }

      home = {
        name: 'Home',
        elements: [
          {
            name: 'Title',
            type: ItemElementType::TEXT,
            external_id: home_title_external_id
          },
          {
            name: 'Slug',
            type: ItemElementType::URL_SLUG,
            depends_on: {
              element: { external_id: home_title_external_id }
            }
          },
          {
            name: 'Posts',
            type: ItemElementType::LINKED_ITEMS
          },
          {
            name: 'Authors',
            type: ItemElementType::LINKED_ITEMS
          },
          {
            type: ItemElementType::TAXONOMY,
            taxonomy_group: {
              codename: @sitemap_taxonomy.codename
            }
          }
        ]
      }

      author = {
        name: 'Author',
        elements: [
          {
            name: 'Name',
            type: ItemElementType::TEXT,
            external_id: author_name_external_id
          },
          {
            name: 'Slug',
            type: ItemElementType::URL_SLUG,
            depends_on: {
              element: { external_id: author_name_external_id }
            }
          },
          {
            name: 'Avatar',
            type: ItemElementType::ASSET
          },
          {
            name: 'Location',
            type: ItemElementType::TEXT
          },
          {
            name: 'Date of birth',
            type: ItemElementType::DATE_TIME
          },
          {
            name: 'Biography',
            type: ItemElementType::TEXT
          },
          {
            type: ItemElementType::TAXONOMY,
            taxonomy_group: {
              codename: @sitemap_taxonomy.codename
            }
          }
        ]
      }

      post = {
        name: 'Blog Post',
        elements: [
          {
            name: 'Title',
            type: ItemElementType::TEXT,
            external_id: post_title_external_id
          },
          {
            name: 'Slug',
            type: ItemElementType::URL_SLUG,
            depends_on: {
              element: { external_id: post_title_external_id }
            }
          },
          {
            name: 'Published',
            type: ItemElementType::DATE_TIME
          },
          {
            name: 'Thumbnail',
            type: ItemElementType::ASSET
          },
          {
            name: 'Authors',
            type: ItemElementType::LINKED_ITEMS
          },
          {
            name: 'Content',
            type: ItemElementType::RICH_TEXT
          },
          {
            type: ItemElementType::TAXONOMY,
            taxonomy_group: {
              codename: @post_categories_taxonomy.codename
            }
          },
          {
            type: ItemElementType::TAXONOMY,
            taxonomy_group: {
              codename: @post_tags_taxonomy.codename
            }
          },
          {
            type: ItemElementType::TAXONOMY,
            taxonomy_group: {
              codename: @sitemap_taxonomy.codename
            }
          }
        ]
      }

      @author_type = creator.create_type(author)
      @page_type = creator.create_type(page)
      @post_type = creator.create_type(post)
      @home_type = creator.create_type(home)
    end

    def create_author(name, location, date_of_birth, biography, avatar_url)
      avatar_url =~ /\/([^\/]*)\/([^\/]*)\.[^\/]*$/
      avatar_name = "#{$1}#{$2}"
      avatar_reference = creator.upload_file_from_url(avatar_url, avatar_name)
      avatar_external_id = Digest::SHA256.hexdigest(avatar_url)

      asset = {
        file_reference: avatar_reference.parse,
        external_id: avatar_external_id,
        descriptions: [
          {
            language: { id: DEFAULT_LANGUAGE_ID },
            description: ''
          }
        ]
      }

      creator.create_asset(asset)

      author_id = Digest::SHA256.hexdigest(name)

      author = {
        name: name,
        type: { codename: @author_type.codename },
        external_id: author_id
      }

      author_variant = {
        elements: [
          {
            element: { codename: 'name' },
            value: name
          },
          {
            element: { codename: 'avatar' },
            value: [{ external_id: avatar_external_id }]
          },
          {
            element: { codename: 'location' },
            value: location
          },
          {
            element: { codename: 'date_of_birth' },
            value: date_of_birth
          },
          {
            element: { codename: 'biography' },
            value: biography
          },
          {
            element: { codename: 'sitemap' },
            value: [{ codename: 'authors' }]
          }
        ]
      }

      creator.create_item(author)
      created_variant = creator.create_variant(author_variant, author_id)
      creator.publish_variant(author_id)
      created_variant
    end

    def create_page(title, content)
      page_id = Digest::SHA256.hexdigest(title)

      page = {
        name: title,
        type: { codename: @page_type.codename },
        external_id: page_id
      }

      page_variant = {
        elements: [
          {
            element: { codename: 'title' },
            value: title
          },
          {
            element: { codename: 'content' },
            value: content
          }
        ]
      }

      creator.create_item(page)
      created_variant = creator.create_variant(page_variant, page_id)
      creator.publish_variant(page_id)
      created_variant
    end

    def get_reference(variant)
      { id: variant.item.id }
    end

    def get_taxonomy_reference(taxonomy_group, term_name)
      term = taxonomy_group.terms.find { |term| term.name == term_name }
      { id: term.id }
    end

    def create_post(title, published, thumbnail_url, authors, content, post_categories, post_tags)
      thumbnail_url =~ /\/([^\/]*)(\.[^\/]*)?$/
      thumbnail_name = $1
      thumbnail_reference = creator.upload_file_from_url(thumbnail_url, thumbnail_name)
      thumbnail_external_id = Digest::SHA256.hexdigest(thumbnail_url)

      asset = {
        file_reference: thumbnail_reference.parse,
        external_id: thumbnail_external_id,
        descriptions: [
          {
            language: { id: DEFAULT_LANGUAGE_ID },
            description: ''
          }
        ]
      }

      creator.create_asset(asset)

      post_id = Digest::SHA256.hexdigest(title)

      post = {
        name: title,
        type: { codename: @post_type.codename },
        external_id: post_id
      }

      post_variant = {
        elements: [
          {
            element: { codename: 'title' },
            value: title
          },
          {
            element: { codename: 'published' },
            value: published
          },
          {
            element: { codename: 'thumbnail' },
            value: [{ external_id: thumbnail_external_id }]
          },
          {
            element: { codename: 'authors' },
            value: authors.map(&method(:get_reference))
          },
          {
            element: { codename: 'content' },
            value: content
          },
          {
            element: { codename: 'post_categories' },
            value: post_categories
          },
          {
            element: { codename: 'post_tags' },
            value: post_tags
          },
          {
            element: { codename: 'sitemap' },
            value: [{ codename: 'posts' }]
          }
        ]
      }

      creator.create_item(post)
      created_variant = creator.create_variant(post_variant, post_id)
      creator.publish_variant(post_id)
      created_variant
    end

    def create_home(name, title)
      home_id = Digest::SHA256.hexdigest(name)

      home = {
        name: title,
        type: { codename: @home_type.codename },
        external_id: home_id
      }

      home_variant = {
        elements: [
          {
            element: { codename: 'title' },
            value: title
          },
          {
            element: { codename: 'slug' },
            value: 'index'
          },
          {
            element: { codename: 'posts' },
            value: [
              get_reference(@post1),
              get_reference(@post2),
              get_reference(@post3),
              get_reference(@post4),
              get_reference(@post5),
              get_reference(@post6)
            ]
          },
          {
            element: { codename: 'authors' },
            value: [
              get_reference(@author1),
              get_reference(@author2),
              get_reference(@author3),
              get_reference(@author4),
              get_reference(@author5)
            ]
          }
        ]
      }

      creator.create_item(home)
      created_variant = creator.create_variant(home_variant, home_id)
      creator.publish_variant(home_id)
      created_variant
    end

    def create_items
      @author1 = create_author(
        'Catherine Munoz',
        'Glen Elder, Kansas(KS)',
        DateTime.parse('1991-10-28').iso8601,
        'Hipster-friendly alcohol lover. Extreme internet advocate. Web geek. Incurable food nerd. Freelance introvert.',
        'https://uinames.com/api/photos/female/2.jpg'
      )

      @author2 = create_author(
        'Christopher Hopkins',
        'San Jose, California(CA)',
        DateTime.parse('1993-06-07').iso8601,
        'Coffee nerd. Extreme foodaholic. Beer evangelist. Alcohol lover. Incurable social media ninja.',
        'https://uinames.com/api/photos/male/6.jpg'
      )

      @author3 = create_author(
        'Emily Black',
        'Phoenix, Arizona(AZ)',
        DateTime.parse('1996-02-14').iso8601,
        'Twitter evangelist. Music trailblazer. Reader. Subtly charming explorer.',
        'https://uinames.com/api/photos/female/24.jpg'
      )

      @author4 = create_author(
        'Lauren Wade',
        'Chicago, Illinois(IL)',
        DateTime.parse('1993-08-28').iso8601,
        'Bacon enthusiast. Music advocate. Beer expert. Incurable food fan. Avid introvert. Freelance entrepreneur. Explorer.',
        'https://uinames.com/api/photos/female/6.jpg'
      )

      @author5 = create_author(
        'Matthew Hunter',
        'Pampa, Texas(TX)',
        DateTime.parse('1995-02-24').iso8601,
        'Unapologetic communicator. Travel geek. Food practitioner. Coffee maven. Avid internet specialist. Music nerd.',
        'https://uinames.com/api/photos/male/7.jpg'
      )

      @about_us = create_page(
        'About us',
        '<p>Dummy.</p>'
      )

      @post1 = create_post(
        'A Habitant Pharetra Phasellus Urna Facilisis',
        DateTime.parse('2019-07-17').iso8601,
        'https://picsum.photos/id/237/500/300',
        [@author1],
        "<h2>A Habitant Pharetra Phasellus Urna Facilisis</h2>\n<h3>Erat Placerat Scelerisque Justo Quam Facilisi</h3>\n<p>Platea praesent. Justo arcu varius nostra est platea lacinia feugiat. Nullam euismod Dictum pretium dictum Sem tellus vitae bibendum. Ullamcorper&nbsp;<em>hendrerit</em>integer condimentum netus neque mauris.</p>\n<p>Platea mus parturient habitasse suscipit rutrum elit magnis aenean et dictum sed&nbsp;<em>auctor</em>&nbsp;vivamus pellentesque cubilia elementum rutrum eu nisi tincidunt, fermentum dapibus montes, urna. Turpis sollicitudin placerat tortor vestibulum pellentesque ante mollis facilisis scelerisque mauris. Sociosqu consequat imperdiet sociis erat elementum&nbsp;<em>imperdiet</em>&nbsp;platea lacus odio netus.</p>\n<p>Donec mollis. Cras hac aenean torquent. Etiam ullamcorper posuere sagittis eu Scelerisque cras. Curae; pulvinar rutrum dapibus mauris sagittis justo odio hac&nbsp;<strong>proin</strong>&nbsp;class sit placerat odio.</p>",
        [
          get_taxonomy_reference(@post_categories_taxonomy, 'Magna et')
        ],
        [
          get_taxonomy_reference(@post_tags_taxonomy, 'Eos')
        ]
      )

      @post2 = create_post(
        'Aptent',
        DateTime.parse('2019-06-04').iso8601,
        'https://picsum.photos/id/239/500/300',
        [@author5, @author3],
        "<h2>Aptent</h2>\n<p>Nascetur tempus. Vivamus vel vestibulum ligula quam hendrerit integer facilisi molestie. Senectus duis ultricies placerat id magna tincidunt&nbsp;<em>elementum</em>&nbsp;habitasse elit nunc vitae. Nec. Blandit dapibus suscipit. Eu per enim. Nibh lacinia mauris. Torquent litora quis. Ridiculus justo.</p>\n<p>Dui iaculis tortor massa quisque scelerisque vivamus faucibus. Class imperdiet mauris purus suspendisse eget class. Nullam consectetuer feugiat nullam dapibus vel enim eleifend placerat amet parturient. Id nibh tincidunt litora.</p>\n<h3>Justo Fermentum Litora</h3>\n<p>Aenean vulputate arcu adipiscing et non metus. Dictumst orci&nbsp;<strong>mus</strong>&nbsp;volutpat lacinia porttitor&nbsp;<em>ac</em>&nbsp;class ac egestas sodales habitasse luctus praesent vestibulum. Euismod enim felis auctor, urna curae; malesuada bibendum aenean. Erat.</p>",
        [
          get_taxonomy_reference(@post_categories_taxonomy, 'Facilisi delenit'),
          get_taxonomy_reference(@post_categories_taxonomy, 'Sed amet')
        ],
        [
          get_taxonomy_reference(@post_tags_taxonomy, 'Elitr'),
          get_taxonomy_reference(@post_tags_taxonomy, 'Eos')
        ]
      )

      @post3 = create_post(
        'Facilisi',
        DateTime.parse('2019-09-12').iso8601,
        'https://picsum.photos/id/685/500/300',
        [@author1],
        "<h2>Facilisi</h2>\n<h3>Enim Per Eros Natoque Proin Fames Libero Habitant</h3>\n<p>Habitasse non scelerisque neque class aenean purus egestas duis bibendum commodo Fringilla ante suspendisse magna tincidunt. Platea pharetra Facilisi suscipit Habitant. Per Ipsum quisque proin accumsan sollicitudin ultricies. Fames. Ante ad enim ac viverra eros ut maecenas scelerisque aptent class, venenatis iaculis&nbsp;<strong>convallis</strong>&nbsp;sociosqu commodo.</p>\n<p>Litora torquent class blandit per sociis leo nibh integer odio. Pede sit sodales sagittis netus. Primis donec aliquet. Dictum hendrerit lorem purus vitae habitasse volutpat. Rutrum id nisi&nbsp;<em>ipsum</em>&nbsp;sollicitudin tempus ligula facilisis sociis at.</p>\n<p>Arcu auctor volutpat dolor vivamus. Elementum sociosqu. Malesuada&nbsp;<strong>ad</strong>&nbsp;leo purus, vestibulum. Blandit. Morbi eget ad curabitur diam in lectus.</p>",
        [
          get_taxonomy_reference(@post_categories_taxonomy, 'Facilisi delenit')
        ],
        [
          get_taxonomy_reference(@post_tags_taxonomy, 'Lorem'),
          get_taxonomy_reference(@post_tags_taxonomy, 'Elitr')
        ]
      )

      @post4 = create_post(
        'Morbi Ad Ipsum',
        DateTime.parse('2019-07-08').iso8601,
        'https://picsum.photos/id/367/500/300',
        [@author2],
        "<h2>Morbi Ad Ipsum</h2>\n<p>At elementum vestibulum sapien netus hac semper egestas. Nam nulla&nbsp;<em>faucibus</em>etiam, senectus eros etiam urna luctus curabitur erat rhoncus posuere duis eu faucibus tristique volutpat erat&nbsp;<em>odio</em>&nbsp;senectus.</p>\n<p>Sociosqu suscipit ultrices aptent, metus nullam cum libero, curae; ad magnis aliquet molestie nibh curabitur, ad nisi vestibulum semper nulla. Pellentesque libero egestas, bibendum purus cum aenean nibh tristique at feugiat netus. Conubia faucibus. Nascetur platea placerat per&nbsp;<strong>tortor</strong>&nbsp;nonummy.</p>\n<h3>Parturient Vel</h3>\n<p>Rhoncus eros sapien. Lacus mus nonummy mollis etiam aenean pede consectetuer laoreet erat eros sollicitudin sollicitudin adipiscing est pellentesque. Penatibus. Consectetuer iaculis cras massa eros vulputate neque leo habitasse neque nullam.</p>",
        [
          get_taxonomy_reference(@post_categories_taxonomy, 'Magna et'),
          get_taxonomy_reference(@post_categories_taxonomy, 'Sed amet')
        ],
        [
          get_taxonomy_reference(@post_tags_taxonomy, 'Eos'),
          get_taxonomy_reference(@post_tags_taxonomy, 'Consequat')
        ]
      )

      @post5 = create_post(
        'Parturient Convallis Nisi Rhoncus Urna',
        DateTime.parse('2019-05-08').iso8601,
        'https://picsum.photos/id/588/500/300',
        [@author4, @author5],
        "<h2>Parturient Convallis Nisi Rhoncus Urna</h2>\n<h3>Posuere Senectus</h3>\n<p>Nascetur cum ullamcorper lorem suspendisse per risus. Nulla pulvinar nulla penatibus&nbsp;<strong>maecenas</strong>&nbsp;per tristique cras molestie dignissim venenatis nullam Inceptos viverra aliquet varius senectus. In vitae at proin.</p>\n<h3>Quisque Pretium Fames Neque Aliquam Inceptos</h3>\n<p>Risus aenean&nbsp;<em>quam</em>&nbsp;orci augue sed. Duis mauris sem integer ultrices. Nec ut ad lorem dis varius libero iaculis lacinia laoreet odio pulvinar venenatis curabitur elementum varius nec purus.&nbsp;<em>Pharetra</em>&nbsp;fusce mauris.</p>\n<p>Id convallis ut fermentum mollis convallis ac massa enim.&nbsp;<em>Curabitur</em>&nbsp;rhoncus egestas turpis lacus. Potenti congue venenatis. Est vivamus inceptos a bibendum a felis placerat vehicula pulvinar ornare magnis malesuada curabitur pretium nunc. Semper erat scelerisque facilisi. Malesuada faucibus cras.</p>",
        [
          get_taxonomy_reference(@post_categories_taxonomy, 'Sed amet')
        ],
        [
          get_taxonomy_reference(@post_tags_taxonomy, 'Diam'),
          get_taxonomy_reference(@post_tags_taxonomy, 'Consequat')
        ]
      )

      @post6 = create_post(
        'Tempor Luctus Imperdiet Massa Id Et',
        DateTime.parse('2019-05-22').iso8601,
        'https://picsum.photos/id/777/500/300',
        [@author1],
        "<h2>Tempor Luctus Imperdiet Massa Id Et</h2>\n<h3>Ullamcorper Aliquet Posuere Lorem</h3>\n<p><em>Pede</em>&nbsp;mi quam parturient libero lacinia auctor magnis nunc vestibulum euismod imperdiet morbi praesent tristique Ullamcorper posuere&nbsp;<em>quis</em>&nbsp;tempus ipsum dolor dapibus morbi a nullam scelerisque nostra mi eget fames quam magna justo.</p>\n<p>Fermentum magna duis pharetra morbi aenean condimentum mus arcu&nbsp;<em>vel</em>vivamus lacus amet torquent dictum vivamus dolor Vivamus. Cursus&nbsp;<strong>ut</strong>&nbsp;turpis dictum nam Ac vitae. Sapien erat vehicula dictumst bibendum. Nonummy turpis mus.</p>\n<h3>A Consequat Malesuada</h3>\n<p>Dapibus vulputate, euismod&nbsp;<em>cubilia</em>&nbsp;feugiat condimentum&nbsp;<strong>orci</strong>&nbsp;lacus&nbsp;<em>id</em>&nbsp;parturient porta tincidunt pharetra interdum tempor. Volutpat ultrices accumsan sagittis torquent suscipit per, aliquet hendrerit mattis dui. Luctus ut adipiscing rutrum. Interdum sapien a facilisis.</p>",
        [
          get_taxonomy_reference(@post_categories_taxonomy, 'Facilisi delenit'),
          get_taxonomy_reference(@post_categories_taxonomy, 'Magna et')
        ],
        [
          get_taxonomy_reference(@post_tags_taxonomy, 'Diam')
        ]
      )

      @home = create_home('Home', 'Welcome to Kentico Cloud Jekyll blog')
    end
  end
end