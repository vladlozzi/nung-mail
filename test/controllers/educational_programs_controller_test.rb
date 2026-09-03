require "test_helper"

class EducationalProgramsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @educational_program = educational_programs(:one)
  end

  test "should get index" do
    get educational_programs_url
    assert_response :success
  end

  test "should get new" do
    get new_educational_program_url
    assert_response :success
  end

  test "should create educational_program" do
    assert_difference("EducationalProgram.count") do
      post educational_programs_url, params: { educational_program: { edu_program: @educational_program.edu_program, edu_program_abbr: @educational_program.edu_program_abbr, specialty: @educational_program.specialty } }
    end

    assert_redirected_to educational_program_url(EducationalProgram.last)
  end

  test "should show educational_program" do
    get educational_program_url(@educational_program)
    assert_response :success
  end

  test "should get edit" do
    get edit_educational_program_url(@educational_program)
    assert_response :success
  end

  test "should update educational_program" do
    patch educational_program_url(@educational_program), params: { educational_program: { edu_program: @educational_program.edu_program, edu_program_abbr: @educational_program.edu_program_abbr, specialty: @educational_program.specialty } }
    assert_redirected_to educational_program_url(@educational_program)
  end

  test "should destroy educational_program" do
    assert_difference("EducationalProgram.count", -1) do
      delete educational_program_url(@educational_program)
    end

    assert_redirected_to educational_programs_url
  end
end
