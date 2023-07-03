class ChangeAuditModelType < ActiveRecord::Migration[7.0]
  def change
    # change audit_model.auditable_type to be a text instead of varchar
    change_column :audit_models, :auditable_type, :text
  end
end
