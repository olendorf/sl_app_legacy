require 'rails_helper'

RSpec.describe "ChuckNorris", type: :request do
  describe "GET /chuck_norris" do
    it "works! (now write some real specs)" do
      get chuck_norris_path
      expect(response).to have_http_status(200)
    end
  end
end
