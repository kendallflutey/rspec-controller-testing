require 'spec_helper'

#Change "ItemController" to the appropriate name
describe ItemController do

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

      let {item_double: double("item_double")}
      # creating a double

      before(:each) do
        Item.stub(:new).and_return(item_double)
        # When the .new method is called on the Item class, return
        # the item_double. This stops the creation of a new instance
        # which stops the test hitting the database.
        get :new
      end

      it "creates a new item" do
        expects(assigns(:item)).to be(item_double)
        #expect the instance of item to be a item_double.
      end
    end
  end


  describe "The #create action" do

    context "Valid params"

      context "hitting the database" do

        it "creates a new isntance of Item" do
          expect{
          # expect can be passed a block
            post :create, item: FactoryGirl.attributes_for(:item)
            # here, you would need an item factory using the FactoryGirl
            # gem. This assigns the item: instance the attributes for an
            # item.
           }.to change(Item,:count).by(1)
           # The rest of the test says the Item model should have one more
           # instance
        end

        #The same test could be written like this
        it "creates a new instance of Item" do
          let(:item) {FactoryGirl.attributes_for(:item)}

          post :create, item: item
          expect(response).to change(Item,:count).by(1)
        end

      end
    end
  end

end















