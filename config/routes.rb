Rails.application.routes.draw do
  # Configuración de Devise con las rutas de registro deshabilitadas
  devise_for :users, skip: [:registrations]

  # Rutas manuales para registro gestionado por UsersController
  as :user do
    get 'users/sign_up', to: 'users#new', as: :new_user_registration
    post 'users', to: 'users#create', as: :user_registration
  end

  # Ruta de cierre de sesión
  devise_scope :user do
    delete 'users/sign_out', to: 'devise/sessions#destroy'
    root to: "devise/sessions#new"
  end

  # Rutas para otras partes de tu aplicación
  resources :samples
  resources :users, only: [:index, :new, :create, :edit, :update, :destroy] # Excluir :show

  # Redirige según el rol del usuario al iniciar sesión
  authenticated :user, lambda { |u| u.admin? } do
    root to: 'users#index', as: :admin_root
  end

  authenticated :user do
    root to: 'samples#index', as: :user_root
  end
end
