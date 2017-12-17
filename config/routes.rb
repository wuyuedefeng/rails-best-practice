Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  defaults format: :json do
    # api
    constraints subdomain: 'api' do
      mount_devise_token_auth_for 'User', at: 'api/auth', controllers: {
          registrations:  'custom_devise_token_auth/registrations',
          sessions:       'custom_devise_token_auth/sessions',
          passwords:      'custom_devise_token_auth/passwords',
          confirmations:  'custom_devise_token_auth/confirmations'
      }
      scope module: 'api' do
        resources :user
      end
    end
    # admin
    constraints subdomain: 'apa' do
      mount_devise_token_auth_for 'Admin', at: 'auth'
      scope module: 'admin' do
        resources :users
      end
    end
  end
end
