class ContentLinkResolver < Kentico::Kontent::Delivery::Resolvers::ContentLinkResolver
  def resolve_link(link)
    <<~LINK
      {% assign link_id = '#{link.id}' %}
      {{ site.pages | where_exp: 'page', 'page.item.system.id == link_id' | map: 'url' | first | relative_url }}
    LINK
  end

  def resolve_404(_id)
    '{{ not_found.html | relative_url }}'
  end
end
