require 'rails_helper'

RSpec.describe "Sections", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/courses/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/courses/show"
      expect(response).to have_http_status(:success)
    end
  end

end
