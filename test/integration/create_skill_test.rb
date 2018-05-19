require 'test_helper'

class CreateSkillTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jayzen)
  end

  test "create skill with valid information" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    get new_skill_path
    assert_template 'skills/new'

    post skills_path, params: { skill: {
      name: "name",
      description: "description",
      weight: 1,
      language: "language"
    }}
    refute_predicate flash, :empty?
  end
end

