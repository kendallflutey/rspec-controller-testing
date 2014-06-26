require 'spec_helper'

#Change "ItemController" to the appropriate name
describe ItemController do
  
  context "hitting the database" do 
	  describe "#edit" do 

	  	#this sets up an insatnce of "Item" to be used in our tests as "item"
	  	#change "Item" and "item" as appropriate
	  	#Also change attributes as needed or swap out for a Factory
	    let(:item) {Item.create(first_attribute: "My name", second_attribute: 23)}

	    #this calls the #get action before each test
	    before(:each) do 
	      get :edit, id: item
	    end

	    #change "item" to appropriate instance
	    it "finds a specific item" do 
	      expect(assigns(:item)).to eq(item)
	    end

	    #there should be nothing to change here unless you render a view other than edit
	    it "renders the edit view" do 
	      expect(response).to render_template("edit")
	    end
	  end
	end


  context "not hitting the database using mocks and doubles" do 

	  describe "#edit" do 

	  	let(:item) {double("item")}

	  	#this calls the #get action before each test
	  	before(:each) do 
	      get :edit, id: item
	    end

	    #uses mocks to test that find was called and the correct id is passed
	    #change "Todo" to the name of your Class
	    it "finds a specific item" do 
	      Todo.should_recieve(:find).once.and_return(item)
	    end


	    #there should be nothing to change here unless you render a view other than edit
	    it "renders the edit view" do 
	      expect(response).to render_template("edit")
	    end
	  end
	end
end
