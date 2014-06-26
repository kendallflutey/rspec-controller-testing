require 'spec_helper'

#Change "ItemController" to the appropriate name
describe ItemController do

  describe "The #new action" do
    # Factoring out the GET :new HTTP request before each test
    # The #new action might not need many tests to begin with
    before(:each) do
      get :new
    end

    # The #new action should create a new object, usually a new
    # instance of a model class
    it "creates a new object" do
      expect(assigns(:object)).to be_a_new(Class)
      # The assigns(:object) is calling the instance variable,
      # @object in your controller. The test then asks, is it
      # an instance of the 'Class'.
    end


  end


end
