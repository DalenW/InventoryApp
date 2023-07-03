class UserAction < ApplicationRecord
  ### ASSOCIATIONS ###
  # ====================================================================================================================

  belongs_to :user, optional: false

  ### ENUMS ###
  # ====================================================================================================================

  enum action: {
    # Restful actions, standard data structure
    get: 0,
    post: 1,
    puts: 2,
    patch: 3,
    delete: 4,

    # Custom actions, non-standard data structure
    audit: 5
  }, _prefix: true

  enum :severity, {
    info: 0, # like a normal page visit
    warning: 1, # adjusting or viewing sensitive data
    dangerous: 2 # where we need to question why they are doing this in the first place
  }

  ### VALIDATIONS ###
  # ====================================================================================================================

  validates :user, presence: true
  validates :action, presence: true
  validates :data, presence: true
  validates :timestamp, presence: true
  validates :severity, presence: true

  ### METHODS ###
  # ====================================================================================================================

  def self.audit?
    false
  end

end
