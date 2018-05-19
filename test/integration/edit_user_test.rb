require 'test_helper'

class EditUserTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jayzen)
  end

  test "edit user with valid information" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    get edit_user_path(@user)
    assert_template 'users/edit'

    patch user_path(@user), params: { user: {
      name: "name",
      city: "city",
      email: "email@email.com",
      description: "description"
    }}
    refute_predicate flash, :empty?
  end
end

