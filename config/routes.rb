Rails.application.routes.draw do
  mount_devise_token_auth_for 'Admin', at: 'apa/auth'
  mount_devise_token_auth_for 'User', at: 'api/auth', controllers: {
    registrations:  'custom_devise_token_auth/registrations',
    sessions:       'custom_devise_token_auth/sessions',
    passwords:      'custom_devise_token_auth/passwords',
    confirmations:  'custom_devise_token_auth/confirmations'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
