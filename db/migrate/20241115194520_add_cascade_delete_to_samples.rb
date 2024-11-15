class AddCascadeDeleteToSamples < ActiveRecord::Migration[6.1]
  def change
    # Elimina la clave foránea existente
    remove_foreign_key :samples, :users

    # Agrega una nueva clave foránea con eliminación en cascada
    add_foreign_key :samples, :users, on_delete: :cascade
  end
end
