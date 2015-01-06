class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, omniauth_providers: [:google_oauth2]

  validates :email, presence: true, format: /\A.*@alliants\.(?:com|co\.uk)\z/
  validates :name, presence: true
  validates :subscription_preference, presence: true
  enum subscription_preference: { unsubscribed: 0, subscribed: 1, admin: 2 }

  scope :subscribed, -> { User.where.not(subscription_preference: User.subscription_preferences[:unsubscribed]) }
  scope :admins, -> { User.where(subscription_preference: User.subscription_preferences[:admin]) }

  def subscribed?
    !unsubscribed?
  end
end
