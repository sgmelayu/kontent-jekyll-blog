module Jekyll
  module CalculateAgeFilter
    def calculate_age(date_of_birth)
      now = Time.now.utc.to_date
      dob = Date.parse(date_of_birth)
      now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
    end
  end
end

Liquid::Template.register_filter(Jekyll::CalculateAgeFilter)
