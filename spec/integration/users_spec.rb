require 'spec_helper'

describe "Users" do
  
  describe "signup" do
  
    describe "failure" do
  
      it "should not make a new user" do
        lambda do
          visit signup_url
          click_button
          response.should render_template('users/new')
          response.should have_tag("div#errorExplanation")
        end.should_not change(User, :count)
      end
    end
    
    describe "success" do

      it "should make a new user" do
        lambda do
          visit signup_url
          fill_in "Name",         :with => "Example User"
          fill_in "Email",        :with => "user@example.com"
          fill_in "Password",     :with => "foobar"
          fill_in "Confirmation", :with => "foobar"
          click_button
          response.should render_template('users/show')
          response.should have_tag("div.flash.success")
        end.should change(User, :count).by(1)
      end
    end    
 end
 
 describe "remember me" do
  
   before(:each) do
     @attr = { :name => "New User", :email => "user@example.com",
               :password => "foobar", :password_confirmation => "foobar" }
     @user = Factory.build(:user, @attr)
     User.stub!(:new).and_return(@user)
   end
  
  it "should have a remember_me! method" do
     @user.should respond_to(:remember_me!)
   end

   it "should have a remember token" do
     @user.should respond_to(:remember_token)
   end

   it "should set the remember token" do
     @user.remember_me!
     @user.remember_token.should_not be_nil
   end
 end
 
 describe "sign in/out" do
   describe "failure" do
     it "should not sign a user in" do
       visit signin_path
       fill_in :email,    :with => ""
       fill_in :password, :with => ""
       click_button
       response.should render_template('sessions/new')
       response.should have_tag("div.flash.error", /invalid/i)
      end
    end

    describe "success" do
      it "should sign a user in and out" do
        user = Factory(:user)
        integration_sign_in user 
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
      end
    end
  end
end
