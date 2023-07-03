class CreateAuditModels < ActiveRecord::Migration[7.0]
  def change
    create_table :audit_models, id: false do |t|
      t.references :auditable, polymorphic: true, null: false, index: false
      t.timestamptz :audit_timestamp, null: false

      # text has no performance penalty over varchar when indexing. Should be good.
      t.text :audit_column, null: false, limit: 255

      t.text :audit_data # the changed data

      t.integer :action, null: false, limit: 1
      t.integer :severity, null: false, limit: 1

      t.references :user, null: false, foreign_key: true, index: true

      t.index [:auditable_type, :auditable_id, :audit_timestamp, :audit_column],
              unique: true,
              name: "index_audit_models_on_auditable_and_timestamp_and_column"
    end
  end
end
