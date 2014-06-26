require 'spec_helper'

#Change "ItemController" to the appropriate name
describe ItemController do
  
  #these tests will hit the database
  #change "item" to the appropriate model/instance name
  describe "#edit" do 

  	#this sets up an insatnce of Item to be used in our tests
    let(:item) {Item.create(first_attribute: "My name", second_attribute: 23)}

    #this calls the #get action before each test
    before(:each) do 
      get :edit, id: item
    end

    #change "item"
    it "finds a specific item" do 
      expect(assigns(:item)).to eq(item)
    end

    #there should be nothing to change here unless you render a view other than edit
    it "renders the edit view" do 
      expect(response).to render_template("edit")
    end
  end
  
end
