require "test_helper"

describe CategoriesController do
  describe 'guest users' do
    describe "index" do
      it "gives back a susccesful response" do
        get categories_path
        must_respond_with :success
      end
      
      it "can get the root path" do
        get root_path
        must_respond_with :success
      end
    end
  end

  describe "Logged in users" do
    before do
      user = users(:orchid)
      perform_login(user)
    end

    describe "index" do
      it "gives back a susccesful response" do
        get categories_path
        must_respond_with :success
      end
      
      it "can get the root path" do
        get root_path
        must_respond_with :success
      end
    end

    describe "create" do
      it "lets a logged in user create a category" do
        params_hash = {
          category: {
            name: "flower"
          }
        }

        expect {
          post '/categories', params: params_hash
        }.must_differ "Category.count", 1
      end

      it "can't create a category with wrong params" do
        params_hash = {
          category: {
            name: nil
          }
        }
          
        post '/categories', params: params_hash
        # must_redirect_to dashboard_path(user.id)
        expect(flash[:warning]).must_equal "Can't create category."
      end
    end
  end
end

