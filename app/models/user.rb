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
  has_many :user_actions

  ### METHODS ###
  # ====================================================================================================================

  def display_name
    email | "User #{id}"
  end
end
