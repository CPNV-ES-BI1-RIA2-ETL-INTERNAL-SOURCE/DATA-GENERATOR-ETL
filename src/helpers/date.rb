# frozen_string_literal: true

# DateFormatters module providing date formatting utilities
module DateFormatters
  def self.get_month(month_number)
    month_names = %w[January February March April May June July August September October November December]
    month_names[month_number.to_i - 1]
  end
end
