class UsersController < ApplicationController
    before_action :authenticate_user! # Obliga a iniciar sesión
    before_action :authorize_role, only: [:index, :new, :create, :destroy] # Solo administradores pueden acceder
    before_action :set_user, only: [:edit, :update, :destroy] # Encuentra al usuario antes de editar, actualizar o eliminar
    before_action :authorize_user, only: [:edit, :update] # Permite la edición solo para el usuario actual o administradores
  
    # Lista todos los usuarios
    def index
      @users = User.all
    end
  
    # Renderiza el formulario para crear un nuevo usuario
    def new
      @user = User.new
    end
  
    # Crea un nuevo usuario
    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to users_path, notice: 'Usuario creado correctamente.'
      else
        flash[:alert] = 'Hubo un error al crear el usuario. Revisa los campos.'
        render :new
      end
    end
  
    # Renderiza el formulario para editar un usuario
    def edit
      # @user ya se inicializa en el before_action :set_user
    end
  
    # Actualiza los datos del usuario
    def update
      if @user.update(user_params)
        redirect_to users_path, notice: 'Usuario actualizado correctamente.'
      else
        flash[:alert] = 'Hubo un error al actualizar el usuario.'
        render :edit
      end
    end
  
    # Elimina un usuario
    def destroy
      if @user.destroy
        redirect_to users_path, notice: 'Usuario eliminado correctamente.'
      else
        redirect_to users_path, alert: 'Hubo un error al eliminar el usuario.'
      end
    end
  
    private
  
    # Permite solo los parámetros necesarios para crear/actualizar un usuario
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :role)
    end
  
    # Encuentra al usuario basado en su ID
    def set_user
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to users_path, alert: 'Usuario no encontrado.'
    end
  
    # Asegura que solo administradores puedan acceder
    def authorize_role
      redirect_to root_path, alert: 'Acceso no autorizado.' unless current_user.admin?
    end
  
    # Permite la edición solo al usuario actual o administradores
    def authorize_user
      redirect_to root_path, alert: 'No autorizado.' unless current_user == @user || current_user.admin?
    end
  end
  