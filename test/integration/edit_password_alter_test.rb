require 'test_helper'

class EditPasswordAlterTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jayzen)
  end

  test "edit user with valid information" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    get edit_password_alter_path(@user)
    assert_template 'password_alters/edit'

    patch password_alter_path(@user), params: { password_alter: {
      old_password: "password",
      password: "new_password",
      password_confirmation: "new_password"
    }}
    refute_predicate flash, :empty?
  end
end

