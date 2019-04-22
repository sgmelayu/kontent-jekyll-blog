require_relative 'constants'

module SampleContent
  class Creator
    include SampleContent::Constants

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

    def create_taxonomy(taxonomy)
      url = "#{base_url}/taxonomies"
      post_request(url, taxonomy)
    end

    def create_asset(asset)
      url = "#{base_url}/assets"
      post_request(url, asset)
    end

    def create_type(type)
      url = "#{base_url}/types"
      post_request(url, type)
    end

    def create_item(item)
      url = "#{base_url}/items"
      post_request(url, item)
    end

    def create_variant(item_variant, external_id)
      url = "#{base_url}/items/external-id/#{external_id}/variants/#{DEFAULT_LANGUAGE_ID}"
      put_request(url, item_variant)
    end

    def publish_variant(external_variant_id)
      url = "#{base_url}/items/external-id/#{external_variant_id}/variants/#{DEFAULT_LANGUAGE_ID}/publish"
      put_request(url)
    end

    private

    def base_url
      "https://manage.kenticocloud.com/v2/projects/#{@project_id}"
    end

    def response_to_ostruct(response)
      JSON.parse(
        response.body.to_s,
        object_class: OpenStruct
      )
    rescue
      nil
    end

    def post_request(url, body)
      response = HTTP
        .headers(headers)
        .post(url, json: body)

      response_to_ostruct(response)
    end

    def put_request(url, body = nil)
      response = HTTP
        .headers(headers)
        .put(url, json: body)

      response_to_ostruct(response)
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
end
