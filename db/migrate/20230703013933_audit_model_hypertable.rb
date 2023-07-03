class AuditModelHypertable < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      SELECT create_hypertable('audit_models', 'audit_timestamp');
    SQL
  end

  def down
    # drop the table
    execute <<-SQL
      DROP TABLE audit_models;
    SQL
  end
end
