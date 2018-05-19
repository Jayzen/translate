require 'test_helper'

class CreateExperienceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jayzen)
  end

  test "create experience with valid information" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    get new_experience_path
    assert_template 'experiences/new'

    post experiences_path, params: { experience: {
      company: "company",
      position: "position",
      description: "description",
      weight: 1,
      time: "time",
      language: "language"
    }}
    refute_predicate flash, :empty?
  end
end

