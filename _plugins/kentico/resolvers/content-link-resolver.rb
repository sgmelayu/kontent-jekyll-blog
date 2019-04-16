class ContentLinkResolver < Jekyll::Kentico::Resolvers::ContentLinkResolver
  def resolve_link(link)
    <<~EOF
      {% assign link_id = '#{link.id}' %}
      {{ site.pages | where_exp: 'page', 'page.item.system.id == link_id' | map: 'url' | first | relative_url }}
    EOF
  end

  def resolve_404(id)
    '{{ not_found.html | relative_url }}'
  end
end