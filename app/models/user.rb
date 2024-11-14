class User < ApplicationRecord
  enum role: { cliente: 0, laboratorista: 1, admin: 2 }

  # Devise módulos
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable

  # Validaciones
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true, if: :password_required?
  validates :role, presence: true, inclusion: { in: roles.keys }

  private

  def password_required?
    new_record? || password.present?
  end
end

