module Jekyll
  module EstimateReadingTimeFilter
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

    private

    def pluralize_with_count(word, count)
      pluralized_word = count == 1 ? word : "#{word}s"
      "#{count} #{pluralized_word}"
    end
  end
end
