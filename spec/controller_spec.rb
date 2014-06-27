require 'spec_helper'

#Change "ItemController" to the appropriate name
describe ItemController do

#--------------------------------------#
#          The #new action          #
#--------------------------------------#
  describe "The #new action" do
    context "hitting the database" do
      # In this context, we are writing tests that will hit the
      # database.

      # Factoring out the GET :new HTTP request before each test
      # The #new action might not need many tests to begin with
      before(:each) do
        get :new
      end

      # The #new action should create a new object, item, usually a new
      # instance of a model class "Item"
      it "creates a new item" do
        expect(assigns(:item)).to be_a_new(Item)
        # The assigns(:item) is calling the instance variable,
        # @item in your controller. The test then asks, is it
        # an instance of the 'Item' class.
      end
    end

    context "Not hitting the database" do
      # In this context, we are writing tests that will NOT hit
      # the database. This can help test speeds, and remove coupling
      # with the model/db.
      let(:item_double) { double("item_double")}
      # creating a double

      before(:each) do
        Item.stub(:new).and_return(item_double)
        # When the .new method is called on the Item class, return
        # the item_double. This stops the creation of a new instance
        # which stops the test hitting the database.
        get :new
      end

      it "creates a new item" do
        expect(assigns(:item)).to be(item_double)
        #expect the instance of item to be a item_double.
      end
    end
  end

#--------------------------------------#
#          The #create action          #
#--------------------------------------#
  describe "The #create action" do
    context "Valid params" do
      context "hitting the database" do
        it "creates a new Item" do
          expect{
          # expect can be passed a block
            post :create, item: FactoryGirl.attributes_for(:item)
            # here, you would need an item factory using the FactoryGirl
            # gem. This assigns the item: instance the attributes for an
            # item.
           }.to change(Item,:count).by(1)
           # The rest of the test says the item model should have one more
           # instance
        end

        it "redirects to the correct url" do
          #in this example we will test the root path
          post :create, item: FactoryGirl.attributes_for(:item)
          expect(response).to redirect_to root_url
        end
      end

      context "not hitting the database" do
        let(:item_double) { double("item_double")}
        before(:each) do
          Item.stub(:new).and_return(item_double)
          item_double.stub(:save).and_return(true)
          # we need to stub the #new and the #save methods on the
          # class and double
        end

        it "creates a new item" do
          post :create
          #expect the instance of item to be a item_double.
          expect(assigns(:item)).to be(item_double)
        end

        it "redirects to the correct url" do
          #in this example we will test the root path
          post :create
          expect(response).to redirect_to root_url
        end
      end
    end
  end

#--------------------------------------#
#          The #edit action          #
#--------------------------------------#
  describe "#edit" do

	  context "hitting the database" do
	 		#this sets up an insatnce of "Item" to be used in our tests as "item"
	  	#change "Item" and "item" as appropriate
	  	#Also change attributes as needed or swap out for a Factory
	    let(:item) {Item.create(first_attribute: "My name", second_attribute: 23)}

	    #this calls the #edit action before each test
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

  	context "not hitting the database using mocks and doubles" do

	  	#this creates a double for item that can be used for further tests
	  	let(:item) {double("item")}

	    #uses mocks to test that find was called and the correct id is passed
	    #change "Todo" to the name of your Class
	    it "finds a specific item" do
	      Todo.should_recieve(:find).once.and_return(item)
	      get :edit, id: item
	    end

	    #there should be nothing to change here unless you render a view other than edit
	    it "renders the edit view" do
	      expect(response).to render_template("edit")
	    end
	  end
	end

#--------------------------------------#
#          The #update action          #
#--------------------------------------#
	describe "#update" do 

		context "hitting the database" do 

			#this sets up an insatnce of "Item" to be used in our tests as "item"
	  	#change "Item" and "item" as appropriate
	  	#Also change attributes as needed or swap out for a Factory
			let(:item) {Item.create(first_attribute: "My name", second_attribute: 23)}


			it "updates an item with valid params" do 
				#this sends a post request to the #update item
				#it also passes the params it needs ("id" & "item") with the update
				post :update, id: item, item: {first_attribute: "Updated name", second_attribute: 23}
				item.reload
				expect(item.first_attribute).to eq("Updated name")
			end

			it "redirects to item once updated" do
				#update "item" throughout as needed
				#sending item: can be done with a factory and one explicit change
				post :update, id: item, item: {first_attribute: "Updated name", second_attribute: 23}
				#change redirect as desired
				expect(response).to redirect_to(item)
			end

			#this test assumes that validates :first_attribute, presence: true is in Item model
			#is redundant if no params validations
			it "renders edit if params are invalid" do 
				post :update, id: item, item: {first_attribute: nil, second_attribute: 23}
				expect(response).to render_template("edit")
			end
		end

		context "not hitting the database" do 

			#this creates a double to stand in place of @item in controller
			let(:todo) {double("todo")}
      let(:attrs) {first_attribute: "Updated name", second_attribute: 23}

			it "updates an item with valid params" do 
				#we define the attrs that we will send through to be updated
			
				Item.stub(:find).and_return(item)
				#declares the method to be called in controller and what it's called with (attrs)
				item.should_recieve(:update_attributes).with(attrs.stringify_keys)
				post :update, id: item, item: attrs
			end

			it "redirects to item once updated" do
				#change "item" and Item as required
				item = stub_model(Item)
				#stubs out find and returns stub_model
				Item.stub(:find).and_return(item)
				item.stub(:update_attributes).and_return(true)
				post :update, id: item, item: attrs
				#change redirect as desired
				expect(response).to redirect_to(item)
			end

			it "renders edit if params are invalid" do 
				#creates a double and defines the behaviour expected from update_attributes method
				item = double("item", update_attributes: false) 
				Item.stub(:find).and_return(item)
				post :update, id: 1, item: item
				#change view to render as required
    		expect(response).to render_template("edit")
			end
		end
	end
end















