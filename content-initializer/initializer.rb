require 'http'
require 'open-uri'

DEFAULT_LANGUAGE_ID = '00000000-0000-0000-0000-000000000000'

def create_sample
  project_id = ENV['PROJECT_ID']
  secure_key = ENV['CM_API_KEY']

  creator = Creator.new project_id, secure_key

  create_types creator
  create_items creator
end

def create_types(creator)
  author = {
    name: 'Author',
    elements: [
      {
        name: 'Name',
        type: 'text'
      },
      {
        name: 'Biography',
        type: 'rich_text'
      }
    ]
  }

  category = {
    name: 'Category',
    elements: [
      {
        name: 'Name',
        type: 'text'
      },
      {
        name: 'Description',
        type: 'rich_text'
      }
    ]
  }

  blog_post = {
    name: 'Blog Post',
    elements: [
      {
        name: 'Title',
        type: 'text'
      },
      {
        name: 'Date',
        type: 'date_time'
      },
      {
        name: 'Authors',
        type: 'modular_content'
      },
      {
        name: 'Categories',
        type: 'modular_content'
      },
      {
        name: 'Image',
        type: 'asset'
      },
      {
        name: 'Content',
        type: 'rich_text'
      },
    ]
  }

  creator.create_type author
  creator.create_type category
  creator.create_type blog_post
end

def create_items(creator)
  random_pic = HTTP.head('https://picsum.photos/200/300/?random').headers['location']
  random_pic_url = "https://picsum.photos/#{random_pic}"

  post_1_asset_reference = creator.upload_file_from_url random_pic_url, 'random_picture.jpg'
  post_1_asset_external_id = 'post_1_asset'

  post_1_asset = {
    file_reference: post_1_asset_reference.parse,
    title: 'Assetos',
    external_id: post_1_asset_external_id,
    descriptions: [
      {
        language: { id: DEFAULT_LANGUAGE_ID },
        description: ''
      }
    ]
  }

  creator.create_asset post_1_asset

  author_1_id = 'author'

  author_1 = {
    name: 'Author 1',
    type: { codename: 'author' },
    external_id: author_1_id
  }

  author_1_variant = {
    elements: [
      {
        element: { codename: 'name' },
        value: 'Jozo'
      },
      {
        element: { codename: 'biography' },
        value: '<p>Sevas Jozo</p>'
      }
    ]
  }

  creator.create_item author_1
  creator.create_variant author_1_variant, author_1_id
  creator.publish_variant author_1_id

  category_1_id = 'category'

  category_1 = {
    name: 'Category 1',
    type: { codename: 'category' },
    external_id: category_1_id
  }

  category_1_variant = {
    elements: [
      {
        element: { codename: 'name' },
        value: 'Travel'
      },
      {
        element: { codename: 'description' },
        value: '<p>Traveling is good</p>'
      }
    ]
  }

  creator.create_item category_1
  creator.create_variant category_1_variant, category_1_id
  creator.publish_variant category_1_id

  post_1_id = 'post'

  post_1 = {
    name: 'Post 1',
    type: { codename: 'blog_post' },
    external_id: post_1_id
  }

  post_1_variant = {
    elements: [
      {
        element: { codename: 'title' },
        value: 'Titleee'
      },
      {
        element: { codename: 'date' },
        value: '2019-02-13T11:15:40+0000'
      },
      {
        element: { codename: 'authors' },
        value: [ { external_id: author_1_id } ]
      },
      {
        element: { codename: 'categories' },
        value: [ { external_id: category_1_id } ]
      },
      {
        element: { codename: 'image' },
        value: [ { external_id: post_1_asset_external_id } ]
      },
      {
        element: { codename: 'content' },
        value: '<p>Content of this post.</p>'
      }
    ]
  }

  creator.create_item post_1
  creator.create_variant post_1_variant, post_1_id
  creator.publish_variant post_1_id
end

class Creator
  def initialize(project_id, secure_key)
    @project_id = project_id
    @secure_key = secure_key
  end

  def upload_file_from_url(file_url, filename)
    response_headers = HTTP.head(file_url).headers
    type = response_headers['Content-Type']
    length = response_headers['Content-Length']

    url = "#{base_url}/files/#{filename}"
    file = open(file_url)

    HTTP
      .headers(image_headers(type, length))
      .post(url, body: file)
  end

  def create_asset(asset)
    url = "#{base_url}/assets"
    post_request url, asset
  end

  def create_type(type)
    url = "#{base_url}/types"
    post_request url, type
  end

  def create_item(item)
    url = "#{base_url}/items"
    post_request url, item
  end

  def create_variant(item_variant, external_id)
    url = "#{base_url}/items/external-id/#{external_id}/variants/#{DEFAULT_LANGUAGE_ID}"
    put_request url, item_variant
  end

  def publish_variant(external_variant_id)
    url = "#{base_url}/items/external-id/#{external_variant_id}/variants/#{DEFAULT_LANGUAGE_ID}/publish"
    put_request url
  end
  private
  def base_url
    "https://manage.kenticocloud.com/v2/projects/#{@project_id}"
  end

  def post_request(url, body)
    HTTP
      .headers(headers)
      .post(url, json: body)
  end

  def put_request(url, body = nil)
    if body
      return HTTP
         .headers(headers)
         .put(url, json: body)
    end

    HTTP
      .headers(headers)
      .put(url)
  end

  def headers
    {
      Authorization: "Bearer #{@secure_key}",
      'Content-Type': 'application/json'
    }
  end

  def image_headers(type, content_length)
    {
      Authorization: "Bearer #{@secure_key}",
      'Content-Type': type,
      'Content-Length': content_length
    }
  end
end

create_sample