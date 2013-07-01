class User < ActiveRecord::Base

  has_many :subscriptions
  has_many :feeds, through: :subscriptions

  has_secure_password

  validates :email,                 presence: true
  validates :password,              presence: { on: :create }
  validates :password_confirmation, presence: { on: :create }
end
