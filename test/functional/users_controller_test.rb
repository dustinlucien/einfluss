require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get scrape" do
    get :scrape
    assert_response :success
  end

end
