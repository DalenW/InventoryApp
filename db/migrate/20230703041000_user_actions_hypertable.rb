class UserActionsHypertable < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      SELECT create_hypertable('user_actions', 'timestamp');
    SQL
  end

  def down
    # drop the table
    execute <<-SQL
      DROP TABLE user_actions;
    SQL
  end
end
