require "test_helper"

class ApplicationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new_import" do
    get applications_new_import_url
    assert_response :success
  end
end
