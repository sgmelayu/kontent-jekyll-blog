class PostFilenameMapper < Jekyll::Kentico::Mappers::FilenameMapperFactory
  def execute
    @item.system.codename
  end
end