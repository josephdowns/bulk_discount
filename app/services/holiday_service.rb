class HolidayService

  def get_array
    response = HTTParty.get("https://date.nager.at/api/v3/PublicHolidays/#{current_year}/US")
    JSON.parse(response.body, symbolize_names: true)
  end

  def current_year
    Time.now.year
  end

end
