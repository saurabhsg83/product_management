class UserController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  def login
    user = User.where(email: params[:email].downcase).first
    if user && user.authenticate(params[:password])
      if user.auth_token.nil?
        user.auth_token = SecureRandom.urlsafe_base64
        user.save
        render :json => {
          :message => 'User Logged in Successfully',
          :payload => {
            :session_token => user.auth_token,
            :user_id => user.id,
            :user_name => user.name
          },:status => 200
        }
      else
        render :json => {
          :message => 'User Already Logged in',
          :payload => {
            :session_token => user.auth_token,
            :user_id => user.id,
            :user_name => user.name
          },:status => 400
        }
      end
    else
      render :json => {
        :message => "Invalid Email/Password: Credentials dont match"
      },:status => 400
    end
  end

  def logout
    session = request.headers['HTTP_SESSION_TOKEN']
    if session.nil?
      render :json => {
      :message => "Bad request: Session token not present"
        }, :status => 400
    else
      user = User.where(:auth_token => session).first
      if user
        user.auth_token = nil
        user.save
        render :json => {
        :message => "Logged out successfully"
        }, :status => 200
      else
        render :json => {
        :message => "Unauthorized request: You are not logged in or Session Token is invalid"
          },:status => 401
      end
    end
  end
end
