class UserMailer < ApplicationMailer
  default from: 'postmaster@sandbox63db1c1226c9447eb445c6fbd6fc7cd1.mailgun.org'

  # Correo de creación de usuario
  def user_created(user)
    @user = user
    mail(to: @user.email, subject: '¡Bienvenido a nuestra plataforma!')
  end

  # Correo de actualización de usuario
  def user_updated(user)
    @user = user
    mail(to: @user.email, subject: 'Tu cuenta ha sido actualizada')
  end
end

