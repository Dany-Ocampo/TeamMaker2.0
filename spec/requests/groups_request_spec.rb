require 'rails_helper'

RSpec.describe "Groups", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/groups/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /my_group" do
    it "returns http success" do
      get "/groups/my_group"
      expect(response).to have_http_status(:success)
    end
  end

end
