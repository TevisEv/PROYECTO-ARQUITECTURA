Rails.application.routes.draw do
  devise_for :users

  # Redirige al login después de cerrar sesión
  devise_scope :user do
    root to: "devise/sessions#new"
  end

  # Rutas para otras partes de tu aplicación
  resources :samples
  resources :users, only: [:index, :new, :create, :edit, :update, :show]

  # Redirige según el rol del usuario al iniciar sesión
  authenticated :user, lambda { |u| u.admin? } do
    root to: 'users#index', as: :admin_root
  end

  authenticated :user do
    root to: 'samples#index', as: :user_root
  end
end





