class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  belongs_to :created_by, class_name: "User"
  belongs_to :updated_by, class_name: "User"

  ### CALLBACKS ###
  # ======================================================================================================================

  before_create :audit_model_changed
  before_update :audit_model_changed

  after_create :audit_model_create
  after_update :audit_model_commit

  after_destroy :audit_model_destroyed

  ### METHODS ###
  # ======================================================================================================================

  ### Audit
  # ----------------------------------------------------------------------------------------------------------------------

  def audit?
    self.audit?
  end

  # whether or not this model is part of the audit system
  def self.audit?
    true
  end

  # columns that are hidden in the audit table. Either columns that don't need to be tracked or that contain sensitive data
  def hidden_columns
    []
  end

  def audit_model_changed
    @audit_model_changed_columns = self.changed
  end

  def audit_model_create
    @audit_model_action = :create

    # technically audit_model_changed is called before this so we only need to overwrite the columns if they are empty
    @audit_model_changed_columns ||= self.class.column_names # snag every column

    audit_model_commit
  end

  def audit_model_destroyed
    @audit_model_action = :destroy

    audit_model_commit
  end

  def audit_model_commit
    return unless audit?

    @audit_model_action ||= :update

    columns_to_always_ignore = [
      :id,
      :updated_by_id,
      :updated_at
    ]

    except_columns = hidden_columns + columns_to_always_ignore

    Thread.new do
      audit_columns = [] # contains the columns we are auditing

      # filter out the columns that we don't want to track
      @audit_model_changed_columns.each do |column|
        next if except_columns.include?(column.to_sym)

        audit_columns << column
      end

      audit_columns.each do |audit_column|
        audit_timestamp = self.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%L%z")
        audit_timestamp = self.created_at.strftime("%Y-%m-%dT%H:%M:%S.%L%z") if @audit_model_action == "create"

        _audit = AuditModel.create(
          auditable: self,
          audit_timestamp:,
          audit_column: audit_column,
          action: @audit_model_action,
          severity: :info,
          data: self.send(audit_column)
        )
      end

      @audit_model_changed_columns = []
    end
  end
end
