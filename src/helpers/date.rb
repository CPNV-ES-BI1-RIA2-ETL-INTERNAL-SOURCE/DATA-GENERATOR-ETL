# frozen_string_literal: true

module DateFormatters

  def self.get_month(i)
    %w[janvier février mars avril mai juin juillet août septembre octobre novembre décembre].at(i.to_i - 1)
  end

end
