require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  context "A user" do
    setup do
      MEMCACHE.flush_all
    end
    
    should "authenticate" do
      @user = Factory.create(:user)
      assert(User.authenticate(@user.name, "password"), "Authentication should have succeeded")
      assert(!User.authenticate(@user.name, "password2"), "Authentication should not have succeeded")
      assert(User.authenticate_hash(@user.name, @user.password_hash), "Authentication should have succeeded")
      assert(!User.authenticate_hash(@user.name, "xxxx"), "Authentication should not have succeeded")
    end
    
    context "name" do
      should "be #{Danbooru.config.default_guest_name} given an invalid user id" do
        assert_equal(Danbooru.config.default_guest_name, User.find_name(-1))
      end
      
      should "be fetched given a user id" do
        @user = Factory.create(:user)
        assert_equal(@user.name, User.find_name(@user.id))
      end
      
      should "be updated" do
        @user = Factory.create(:user)
        @user.update_attribute(:name, "danzig")
        assert_equal("danzig", User.find_name(@user.id))
      end
    end
    
    context "password" do
      should "match the confirmation" do
        @user = Factory.create(:user)
        @user.password = "zugzug5"
        @user.password_confirmation = "zugzug5"
        @user.save
        @user.reload
        assert(User.authenticate(@user.name, "zugzug5"), "Authentication should have succeeded")
      end
    
      should "match the confirmation" do
        @user = Factory.create(:user)
        @user.password = "zugzug6"
        @user.password_confirmation = "zugzug5"
        @user.save
        assert_equal(["Password doesn't match confirmation"], @user.errors.full_messages)
      end
    
      should "not be too short" do
        @user = Factory.create(:user)
        @user.password = "x5"
        @user.password_confirmation = "x5"
        @user.save
        assert_equal(["Password is too short (minimum is 5 characters)"], @user.errors.full_messages)
      end
    
      should "should be reset" do
        @user = Factory.create(:user)
        new_pass = @user.reset_password
        assert(User.authenticate(@user.name, new_pass), "Authentication should have succeeded")
      end
    end
  end
end
