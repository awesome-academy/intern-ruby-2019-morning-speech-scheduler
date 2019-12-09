require 'rails_helper'

RSpec.describe ChangesPasswordController, type: :controller do
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
    let!(:user){FactoryBot.create :user, password: "phu123"}
    before{session[:user_id] = user.id}

    describe "Valid attribute" do
      before do
        put :update, params: {id: user.id,
          user:{password_old: "phu123", password: "123456", password_confirmation: "123456"}}
      end

      context "Change user attribute" do
        it{expect{user.reload}.to change{user.password_digest}}
      end

      context "Redirect to user infomation" do
        it{expect(response).to redirect_to(user_path)}
      end
    end

    describe "Invalid attribute" do
      before do
        put :update, params:{id: user.id,
          user:{password_old: "phu1234", password: "123456", password_confirmation: "1234567"}}
      end

      context "Does not change user attribute" do
        it{expect{user.reload}.not_to change{user.password_digest}}
      end

      context "Render template edit" do
        it{expect(response).to render_template(:edit)}
      end
    end
  end
end
