require 'rails_helper'

RSpec.describe MorningSpeechScheduleController, type: :controller do
  let!(:users){FactoryBot.create_list :user, 10}

  describe "GET #index" do
    let!(:calendars){FactoryBot.create_list :calendar, 10}

    before{get :index, xhr: true}

    context "Return to success response" do
      it{expect(response.status).to eq(200)}
    end

    context "Render data json" do
      it{expect(response.body).to eq(calendars.to_json(include:{user:{only: :name}}))}
    end
  end

  describe "GET #new" do
    before{get :new}

    context "Return to success response" do
      it{expect(response.status).to eq(200)}
    end

    context "Render new template" do
      it{expect(response).to render_template(:new)}
    end
  end

  describe "POST #create" do
    describe "Ajax create one schedule" do
      before{post :create, xhr: true, params:{start: DateTime.now.to_s, end: DateTime.tomorrow.to_s}}

      context "Return to success response" do
        it{expect(response.status).to eq(200)}
      end

      context "Create new calendar valid day" do
        it{expect(Calendar.count).to eq 2}
      end

      context "Render data json" do
        it{expect(response.body).to eq(Calendar.last.to_json(include:{user:{only: :name}}))}
      end
    end

    describe "Create not ajax, mutil schedule valid day" do
      before{post :create, params:{start: DateTime.now.to_s, end: DateTime.tomorrow.to_s}}

      context "Return to success response" do
        it{expect(response.status).to eq(302)}
      end

      context "Create new calendar" do
        it{expect(Calendar.count).to eq 2}
      end

      context "Redirect to index calendar" do
        it{expect(response).to redirect_to(morning_speech_schedule_index_path)}
      end
    end
  end

  describe "PUT #update" do
    let!(:calendar){FactoryBot.create :calendar,day: DateTime.now, tag: "speech"}

    describe "Valid attribute" do
      before{put :update, xhr: true, params:{id: calendar.id, day: DateTime.tomorrow.to_s}}

      context "Return to success response" do
        it{expect(response.status).to eq(200)}
      end

      context "Change calendar attribute" do
        it{expect(calendar.reload.day).to eq(DateTime.tomorrow)}
      end

      context "Render data json" do
        it{expect(response.body).to eq(calendar.reload.to_json(include:{user:{only: :name}}))}
      end
    end

    describe "Invalid attribute" do
      before{put :update, xhr: true, params:{id: calendar.id, day: DateTime.yesterday.to_s}}

      context "Change calendar attribute" do
        it{expect(calendar.reload.day.to_s).not_to eq(DateTime.yesterday.to_s)}
      end

      context "Render data json" do
        it{expect(response.body).not_to eq(calendar.reload.to_json(include:{user:{only: :name}}))}
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:calendar){FactoryBot.create :calendar,tag: "speech"}
    before{delete :destroy, xhr: true, params:{id: calendar.id}}

    context "Delete calendar" do
      it{expect(Calendar.count).to eq 0}
    end

    context "Render data json" do
      it{expect(response.body).to eq(calendar.to_json(include:{user:{only: :name}}))}
    end
  end
end
