class ContentLinkResolver < Jekyll::Kentico::Resolvers::ContentLinkResolver
  def resolve_link(link)
    url = get_url link
    url && "#{@base_url}/#{url}"
  end

private
  def get_url(link)
    "/#{link.code_name}" if link.type == 'taxonomied_page'
  end
end