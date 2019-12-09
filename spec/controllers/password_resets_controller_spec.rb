require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do
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
    let!(:user){FactoryBot.create :user}

    describe "Valid user" do
      before{post :create, params:{password_reset:{email: user.email}}}

      context "Return to success response" do
        it{expect(response.status).to eq(302)}
      end

      context "Create new reset digest" do
        it{expect{user.reload}.to change{user.reset_digest}}
      end

      context "Redirects to the home page" do
        it{expect(response).to redirect_to(root_url)}
      end
    end

    describe "Invalid user" do
        before{post :create, params:{password_reset:{email: nil}}}

      context "Does not create reset digest" do
        it{expect{user.reload}.not_to change{user.reset_digest}}
      end

      context "Render template new reset password" do
        it{expect(response).to render_template(:new)}
      end
    end
  end

  describe "GET #edit" do
    let!(:user){FactoryBot.create :user}

    before do
      user.create_reset_digest
      get :edit, params:{email: user.email, id: user.reset_token}
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
        user.create_reset_digest
        put :update, params:{email: user.email, id: user.reset_token,
          user:{password: "123456", password_confirmation: "123456"}}
      end

      context "Change user attribute" do
        it{expect{user.reload}.to change{user.password_digest}}
      end

      context "Redirect to user infomation" do
        it{expect(response).to redirect_to(root_url)}
      end
    end

    describe "Invalid attribute" do
      before do
        user.create_reset_digest
        put :update, params:{email: user.email, id: user.reset_token,
          user:{password: "123456", password_confirmation: "1234567"}}
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
