
module SearchApiResponse
  def self.response(query_params)
    {
      :stop => {
        :id => "8504200",
        :name => query_params[:stop],
        :type => "train",
        :x => "539084",
        :y => "181463",
        :lon => 6.640943,
        :lat => 46.78155
      },
      :connections => [
        {
          :time => "#{query_params[:date]}T00:31:00",
          :type => "train",
          :line => "R",
          :operator => "SBB",
          :color => "ff0000",
          :type_name => "Regio",
          :terminal => {
            :id => "8504201",
            :name => "Grandson",
            :x => 539084,
            :y => 181463,
            :lon => 6.641953,
            :lat => 46.806287
          },
          :track => "1",
          :subsequent_stops => [
            {
              :id => "8504201",
              :name => "Grandson",
              :x => 539084,
              :y => 181463,
              :lon => 6.641953,
              :lat => 46.806287,
              :arr => "1970-01-01T00:36:00",
              :dep => nil
            }
          ]
        }
      ]
    }
  end
end