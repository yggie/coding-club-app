class Newsletter < ActiveRecord::Base
  HEADER_IMAGE_PATH = 'mailerheader_03.jpg'

  belongs_to :author, class_name: 'User', foreign_key: :user_id

  validates :author, presence: true
  validates :subject, presence: true
  validates :body, presence: true

  def readonly?
    self.sent_at || self.sent_at_changed?
  end
end
