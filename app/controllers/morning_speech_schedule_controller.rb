class MorningSpeechScheduleController < ApplicationController
  protect_from_forgery

  before_action :load_calendar, only: %i(update destroy)

  def index
    return unless request.xhr?

    @calendars = Calendar.calendar_speech
    render json: @calendars.to_json(include: {user: {only: :name}})
  end

  def new; end

  def create
    weekdays = working_day params[:start], params[:end]
    check = Calendar.new_ms_schedule weekdays

    if check && request.xhr?
      render json: Calendar.last.to_json(include: {user: {only: :name}})
    elsif check
      flash[:success] = t ".success"
      redirect_to morning_speech_schedule_index_path
    else
      flash[:danger] = t ".failed"
      render :new
    end
  end

  def update
    return unless request.xhr?

    @calendar.day = params[:day]

    return unless @calendar.save && @calendar.update_last_speech
    render json: @calendar.to_json(include: {user: {only: :name}})
  end

  def destroy
    return unless request.xhr?

    @calendar.destroy

    return unless @calendar.destroyed? && @calendar.update_last_speech
    render json: @calendar.to_json(include: {user: {only: :name}})
  end

  private

  def load_calendar
    @calendar = Calendar.find_by id: params[:id]

    return if @calendar
    render json: @calendar.to_json
  end
end
