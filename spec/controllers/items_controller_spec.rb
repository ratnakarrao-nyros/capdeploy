require 'spec_helper'

describe ItemsController do
  describe "GET show" do
    it "should render show template" do
      item = Fabricate(:item)
      get :show, :id => item.id.to_s
      response.should render_template(:show)
    end
  end
end
