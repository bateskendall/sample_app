require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test "layout links" do
    # Test links when not logged in.
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", "http://news.railstutorial.org/", "News"
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", user_path(@user), false
    assert_select "a[href=?]", edit_user_path(@user), false
    assert_select "a[href=?]", logout_path, false
    
    get contact_path
    assert_select "title", full_title("Contact")
    
    get signup_path
    assert_select "title", full_title("Sign up")
    
    # Test links when logged in.
    log_in_as(@user)

    get root_path
    assert_select "a[href=?]", login_path, false
    assert_select "a[href=?]", user_path(@user), "Profile"
    assert_select "a[href=?]", edit_user_path(@user), "Settings"
    assert_select "a[href=?]", logout_path, "Log out"

    get users_path
    assert_select "title", full_title("All users")
    assert_select "li" do |users|
      assert_select "a[href=?]", user_path(@user), @user.name
    end
  end
end
