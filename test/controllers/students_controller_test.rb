require "test_helper"

class StudentsControllerTest < ActionDispatch::IntegrationTest
  test "should get new_import" do
    get students_new_import_url
    assert_response :success
  end
end
