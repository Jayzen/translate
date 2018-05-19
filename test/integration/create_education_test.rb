require 'test_helper'

class CreateEducationTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jayzen)
  end

  test "create education with valid information" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    get new_education_path
    assert_template 'educations/new'

    post educations_path, params: { education: {
      school: "school",
      degree: "degree",
      time: "time",
      major: "major",
      gpa: 3.5,
      weight: 1,
      language: "language"
    }}
    refute_predicate flash, :empty?
  end
end

