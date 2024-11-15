class UsersController < ApplicationController
  before_action :authenticate_user! # Obliga a iniciar sesión
  before_action :authorize_role, only: [:index, :new, :create, :destroy] # Solo administradores pueden acceder
  before_action :set_user, only: [:edit, :update, :destroy] # Encuentra al usuario antes de editar, actualizar o eliminar
  before_action :authorize_user, only: [:edit, :update] # Permite la edición solo para el usuario actual o administradores
  before_action :set_locale # Configura el idioma para cada solicitud

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
    generated_password = params[:user][:password].presence || SecureRandom.hex(8)

    # Crea el usuario con la contraseña generada
    @user = User.new(user_params.merge(password: generated_password, password_confirmation: generated_password))

    if @user.save
      send_user_created_email(@user, generated_password) # Enviar correo de bienvenida
      flash[:notice] = 'Usuario creado correctamente. Se ha enviado un correo al usuario.'
      redirect_to users_path
    else
      flash.now[:alert] = 'Hubo un error al crear el usuario. Verifique los campos marcados.'
      Rails.logger.debug("Errores al crear usuario: #{@user.errors.full_messages}")
      render :new
    end
  end

  # Renderiza el formulario para editar un usuario
  def edit; end

  # Actualiza los datos del usuario
  def update
    if @user.update(user_params)
      send_user_updated_email(@user) # Enviar correo de actualización
      flash[:notice] = 'Usuario actualizado correctamente. Se ha enviado un correo al usuario.'
      redirect_to users_path
    else
      flash.now[:alert] = 'Hubo un error al actualizar el usuario. Verifique los campos marcados.'
      Rails.logger.debug("Errores al actualizar usuario: #{@user.errors.full_messages}")
      render :edit
    end
  end

  # Elimina un usuario
  def destroy
    if @user.destroy
      flash[:notice] = 'Usuario eliminado con éxito.'
    else
      flash[:alert] = 'Hubo un error al intentar eliminar el usuario.'
    end
    redirect_to users_path
  end

  private

  # Permite solo los parámetros necesarios para crear/actualizar un usuario
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role)
  end

  # Configuración del idioma
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  # Encuentra al usuario basado en su ID
  def set_user
    @user = User.find_by(id: params[:id])
    redirect_to users_path, alert: 'Usuario no encontrado.' unless @user
  end

  # Asegura que solo administradores puedan acceder
  def authorize_role
    redirect_to root_path, alert: 'Acceso no autorizado.' unless current_user.admin?
  end

  # Permite la edición solo al usuario actual o administradores
  def authorize_user
    redirect_to root_path, alert: 'No autorizado.' unless current_user == @user || current_user.admin?
  end

  # Envía correo de bienvenida al crear un usuario
  def send_user_created_email(user, password)
    UserMailer.welcome_email(user, password).deliver_now
  rescue StandardError => e
    Rails.logger.error("Error al enviar correo de creación: #{e.message}")
    flash[:alert] = 'Usuario creado, pero hubo un error al enviar el correo de bienvenida.'
  end

  # Envía correo al actualizar un usuario
  def send_user_updated_email(user)
    UserMailer.user_updated(user).deliver_now
  rescue StandardError => e
    Rails.logger.error("Error al enviar correo de actualización: #{e.message}")
    flash[:alert] = 'Usuario actualizado, pero hubo un error al enviar el correo.'
  end
end
