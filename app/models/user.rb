class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         # :recoverable,
         :rememberable,
         :validatable,
         # :confirmable,
         :lockable,
         :timeoutable,
         :trackable

  ### ASSOCIATIONS ###
  # ======================================================================================================================

  has_many :audit_models, as: :auditable

  ### METHODS ###
  # ====================================================================================================================

  def display_name
    email | "User #{id}"
  end
end
