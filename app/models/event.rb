class Event < ActiveRecord::Base
  belongs_to :user

  extend FriendlyId
  friendly_id :date, use: :slugged
  has_paper_trail

  validates :title, presence: true
  validates :summary, presence: true
  validates :date, presence: true

  validate :date_not_in_the_past

  scope :upcoming, -> { where(['date > ?', Date.today]).order('events.date ASC') }
  scope :archived, -> { where(['date < ?', Date.today]).order('events.date ASC') }

  def host_name
    user ? user.name : 'Guest host'
  end

  def host_profile_image_url
    (user && user.profile_image_url) ? user.profile_image_url : 'http://www.gravatar.com/avatar/00000000000000000000000000000000?d=mm&f=y'
  end

  def date_not_in_the_past
    if self.date && self.date < Date.today
      self.errors.add(:date, 'cannot be in the past')
    end
  end
end
