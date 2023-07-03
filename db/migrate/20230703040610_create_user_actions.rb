class CreateUserActions < ActiveRecord::Migration[7.0]
  def up
    create_table :user_actions, id: false do |t|
      t.belongs_to :user, null: false, index: true, foreign_key: true
      t.timestamptz :timestamp, null: false

      # team id should go here

      t.integer :action, null: false, limit: 1, index: true
      t.integer :severity, null: false, limit: 1, index: true
      t.inet :ip_address, index: true
      t.integer :response_code, limit: 2

      t.jsonb :data

      t.index [:user_id, :timestamp], unique: true
    end
  end

  def down
    # drop table if it exists. It could be dropped by a future migration
    drop_table :user_actions if table_exists? :user_actions
  end
end
