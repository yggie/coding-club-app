class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :newsletters

  validates :email, presence: true, format: /\A.*@alliants\.com\z/
  validates :name, presence: true
end
