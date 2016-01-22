class ProductController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  before_action :authorize_user

  def delete
    product_service = ProductService.new(params)
    response = product_service.delete
    render :json => {
    :message => response[:message],
    :meta => response[:meta]
    }, :status => response[:status]
  end

  def create
    if @user.is_admin?
      product_service = ProductService.new(params)
      response = product_service.create_product
      render :json => {
        :message => response[:message],
        :meta => response[:meta]
      },:status => response[:status]
    else
      render :json => {
        :message => "Unauthorized request: Only admin can create an item"
      },:status => 401
    end
  end

  def update
    if @user.is_admin?
      product_service = ProductService.new(params)
      response = product_service.update_product
      render :json => response[:message], :status => response[:status]
    else
      render :json => {
        :message => "Unauthorized request: Only admin can edit the item"
      },:status => 401
    end
  end

  def search
    product_service = ProductService.new(params)
    response = product_service.search_products
    render :json => {
      :payload => response[:data],
      :meta => response[:meta],
      :message => response[:message]
    },:status => response[:status]
  end

  def show
    product_service = ProductService.new(params)
    response = product_service.fetch_product
    render :json => {
      :payload => response[:data],
      :message => response[:message]
    },:status => response[:status]
  end

  def authorize_user
    session = request.headers['HTTP_SESSION_TOKEN']
    if session.nil?
      render :json => {
        :message => "Bad request: Session token not present"
      }, :status => 400
    else
      @user = User.where(:auth_token => session).first
      if @user.nil?
        render :json => {
          :message => "Unauthorized request: You are not logged in or Session Token is invalid"
        },:status => 401
      end
    end
  end
end
