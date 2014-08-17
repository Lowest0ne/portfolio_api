Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      get 'hello' => 'hello_worlds#hello'

      resources :projects

    end
  end

end
