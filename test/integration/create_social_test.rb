require 'test_helper'

class CreateSocialTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jayzen)
  end

  test "create social with valid information" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    get new_social_path
    assert_template 'socials/new'

    post socials_path, params: { social: {
      name: "name",
      url: "https://www.youtube.com/watch?v=Zq56dBMPolA",
      weight: 1
    }}
    refute_predicate flash, :empty?
  end
end

