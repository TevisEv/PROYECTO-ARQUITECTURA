class Sample < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: 'user_id' # Cliente
  belongs_to :laboratorista, class_name: 'User', foreign_key: 'laboratorista_id' # Laboratorista

  validates :code, presence: true, uniqueness: true
  validates :results, presence: true
end

