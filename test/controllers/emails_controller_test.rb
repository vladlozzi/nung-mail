require "test_helper"

class EmailsControllerTest < ActionDispatch::IntegrationTest
  test "should get new_import" do
    get emails_new_import_url
    assert_response :success
  end
end
