class HolidayFacade
  def service
    HolidayService.new
  end

  def all_holidays
    data = service.get_array
    holidays = []
    data.each do |hash|
      holidays << Holiday.new(hash)
    end
    holidays
  end

  def upcoming
    next_holidays = all_holidays.find_all { |holiday| holiday.date > Time.now }
    next_holidays[0..2]
  end
end
