require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  describe "GET #home" do
    before{get :home}

    context "Return to success response" do
      it{expect(response.status).to eq 200}
    end

    context "Return home template" do
      it{expect(response).to render_template :home}
    end
  end

  describe "GET #about" do
    before{get :about}

    context "Return to success response" do
      it{expect(response.status).to eq 200}
    end

    context "Return about template" do
      it{expect(response).to render_template :about}
    end
  end

  describe "GET #help" do
    before{get :help}

    context "Return to success response" do
      it{expect(response.status).to eq 200}
    end

    context "Return help template" do
      it{expect(response).to render_template :help}
    end
  end
end
