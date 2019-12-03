class MorningSpeechScheduleController < ApplicationController
  def index
    return unless request.xhr?

    @calendars = Calendar.calendar_speech
    render json: @calendars.to_json(include: {user: {only: :name}})
  end

  def new; end

  def create
    weekdays = working_day params[:start], params[:end]

    if Calendar.new_ms_schedule(weekdays)
      flash[:success] = t ".success"
      redirect_to morning_speech_schedule_index_path
    else
      flash[:danger] = t ".failed"
      render :new
    end
  end
end
