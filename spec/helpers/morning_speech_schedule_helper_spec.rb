require 'rails_helper'

RSpec.describe MorningSpeechScheduleHelper, type: :helper do
  describe "#working_day" do
    let(:start_day){"2019-12-09"}
    let(:end_day){"2019-12-15"}
    let(:weekdays){["2019-12-09 07:45:00", "2019-12-10 07:45:00", "2019-12-11 07:45:00", "2019-12-12 07:45:00", "2019-12-13 07:45:00"]}

    it "Day is working day" do
      expect(working_day start_day, end_day).to eq weekdays
    end
  end
end
