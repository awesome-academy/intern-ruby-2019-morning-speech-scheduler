class Calendar < ApplicationRecord
  belongs_to :user

  scope :calendar_speech, -> {where tag: Settings.calendars.tag.speech}
  scope :day_desc, -> {order day: :desc}

  class << self
    def new_ms_schedule weekdays
      User.transaction do
        User.limit(weekdays.count).last_speech_asc.each_with_index do |user, index|
          user.calendars.create! day: weekdays[index], tag: Settings.calendars.tag.speech
          user.update! last_speech: weekdays[index]
        end

        true
      end

      rescue
        false
    end
  end

  def update_last_speech
    last_calendar = user.calendars.day_desc.first
    user.update_attribute :last_speech, last_calendar&.day
  end
end
