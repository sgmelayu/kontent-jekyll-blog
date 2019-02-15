require 'date'

class PostFilenameMapper < Jekyll::Kentico::PageFilenameMappers::Base
  def map(item)
    date = Date.parse item.elements.date.value
    codename = item.system.codename
    "#{date}-#{codename}"
  end
end