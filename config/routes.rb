Rails.application.routes.draw do

  scope '/product_management' do
    get 'product/:id' => 'product#show'
    post 'product'  => 'product#create'
    put 'product/:id'  => 'product#update'
    delete 'product/:id'  => 'product#delete'
    get 'product/search/:name'  => 'product#search'
  end

  post 'login' => 'user#login'
  post 'logout' => 'user#logout'
end
