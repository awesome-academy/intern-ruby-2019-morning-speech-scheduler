module MorningSpeechScheduleHelper
  def working_day start_day, end_day
    start_day = DateTime.parse(start_day).to_date
    end_day = DateTime.parse(end_day).to_date
    wdays = Settings.calendars.working_day
    weekdays = (start_day..end_day).reject{|day| wdays.include? day.wday}
    weekdays = weekdays.map {|d| d + 7.hours + 45.minutes}
  end
end
