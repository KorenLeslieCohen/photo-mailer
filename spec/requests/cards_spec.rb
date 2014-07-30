require 'rails_helper'

RSpec.describe "Cards", :type => :request do
  describe "GET /cards" do
    it "works! (now write some real specs)" do
      get cards_path
      expect(response.status).to be(200)
    end
  end
end
