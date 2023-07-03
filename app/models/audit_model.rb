class AuditModel < ApplicationRecord
  ### ENUMS ###
  # ====================================================================================================================

  enum action: {
    create: 0,
    update: 1,
    destroy: 2
  }, _prefix: true

  enum severity: {
    info: 0,
    warning: 1,
    dangerous: 2
  }

  ### ASSOCIATIONS ###
  # ====================================================================================================================

  belongs_to :auditable, polymorphic: true

  ### VALIDATIONS ###
  # ====================================================================================================================

  # validate everything to true
  validates :auditable, presence: true
  validates :audit_timestamp, presence: true
  validates :audit_column, presence: true
  validates :action, presence: true
  validates :severity, presence: true
  # validates :data, presence: true # it's possible that the data is empty if the user removed it.

  ### METHODS ###
  # ====================================================================================================================

  # get the previous record
  def record_was
    self.class.where(auditable: auditable, audit_column:).where("audit_timestamp < ?", audit_timestamp).order(audit_timestamp: :desc).limit(1).first
  end

  def previous
    record_was
  end
end
