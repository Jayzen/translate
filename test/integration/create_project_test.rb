require 'test_helper'

class CreateProjectTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jayzen)
  end

  test "create project with valid information" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    get new_project_path
    assert_template 'projects/new'

    post projects_path, params: { project: {
      name: "name",
      tag: "tag",
      time: "time",
      description: "description",
      weight: 1,
      language: "language"
    }}
    refute_predicate flash, :empty?
  end
end

