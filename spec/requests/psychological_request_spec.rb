require 'rails_helper'

RSpec.describe "Psychologicals", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/psychological/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /test" do
    it "returns http success" do
      get "/psychological/test"
      expect(response).to have_http_status(:success)
    end
  end

end
