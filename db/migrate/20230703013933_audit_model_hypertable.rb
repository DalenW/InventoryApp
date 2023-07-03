class AuditModelHypertable < ActiveRecord::Migration[7.0]
  def up
    execute "SELECT create_hypertable('audit_models', 'audit_timestamp');"
  end

  def down
    execute "DROP TABLE audit_models;"
  end
end
