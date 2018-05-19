require 'test_helper'

class EditSetTemplateTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jayzen)
  end

  test "edit set_template with valid information" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    get edit_set_template_path(@user)
    assert_template 'set_templates/edit'

    patch set_template_path(@user), params: { set_template: {
      template: 1
    }}
    refute_predicate flash, :empty?

    patch set_template_path(@user), params: { set_template: {
      template: 2
    }}
    refute_predicate flash, :empty?
  end
end

