require "rails_helper"

RSpec.describe ChuckNorrisController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/chuck_norris").to route_to("chuck_norris#index")
    end

    it "routes to #new" do
      expect(:get => "/chuck_norris/new").to route_to("chuck_norris#new")
    end

    it "routes to #show" do
      expect(:get => "/chuck_norris/1").to route_to("chuck_norris#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/chuck_norris/1/edit").to route_to("chuck_norris#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/chuck_norris").to route_to("chuck_norris#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/chuck_norris/1").to route_to("chuck_norris#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/chuck_norris/1").to route_to("chuck_norris#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/chuck_norris/1").to route_to("chuck_norris#destroy", :id => "1")
    end
  end
end
