require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #show" do
    let!(:user){FactoryBot.create :user}

    before{get :show, params:{id: user.id}}

    context "Return to success response" do
      it{expect(response.status).to eq(200)}
    end

    context "Assigns @user" do
      it{expect(assigns(:user)).to eq(user)}
    end

    context "Render show template" do
      it{expect(response).to render_template(:show)}
    end
  end

  describe "GET #edit" do
    let!(:user){FactoryBot.create :user}

    before do
      session[:user_id] = user.id
      get :edit, params:{id: user.id}
    end

    context "Return to success response" do
      it{expect(response.status).to eq(200)}
    end

    context "Assigns @user" do
      it{expect(assigns(:user)).to eq(user)}
    end

    context "Render edit template" do
      it{expect(response).to render_template(:edit)}
    end
  end

  describe "PUT #update" do
    let!(:user){FactoryBot.create :user}

    describe "Valid attribute" do
      before do
        session[:user_id] = user.id
        put :update, params:{id: user.id, user: FactoryBot.attributes_for(:user, name: "Doan Phu")}
      end

      context "Located request user" do
        it{expect(assigns(:user)).to eq(user)}
      end

      context "Change user attribute" do
        it{expect(user.reload.name).to eq("Doan Phu")}
      end

      context "Redirect to user infomation" do
        it{expect(response).to redirect_to(user_path(assigns(:user)))}
      end
    end

    describe "Invalid attribute" do
      before do
        session[:user_id] = user.id
        put :update, params:{id: user.id, user: FactoryBot.attributes_for(:user, name: nil)}
      end

      context "Does not save new user" do
        it{expect{put :update, params:{id: user.id, user: FactoryBot.attributes_for(:user, name: nil)}}.to_not change(User, :count)}
      end

      context "Does not change user attribute" do
        it{expect(user.reload.name).not_to be_nil}
      end

      context "Render template edit" do
        it{expect(response).to render_template(:edit)}
      end
    end
  end
end
