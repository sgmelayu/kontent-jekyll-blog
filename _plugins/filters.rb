module ReadingTimeFilter
  def reading_time(input)
    time = (input.split.size * 180).floor
    "yolo: #{time}"
  end
end

Liquid::Template.register_filter(ReadingTimeFilter)