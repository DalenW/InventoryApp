class UserCreatedAndUpdatedBy < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :created_by, foreign_key: { to_table: :users }, null: false
    add_reference :users, :updated_by, foreign_key: { to_table: :users }, null: false
  end
end
