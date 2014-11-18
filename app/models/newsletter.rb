class Newsletter < ActiveRecord::Base
  HEADER_IMAGE_PATH = 'mail-header.jpg'

  belongs_to :author, class_name: 'User', foreign_key: :user_id

  validates :author, presence: true
  validates :subject, presence: true
  validates :body, presence: true

  scope :drafts, -> { where(sent_at: nil) }
  scope :archived, -> { where.not(sent_at: nil) }

  def readonly?
    (self.sent_at && !self.sent_at_changed?) || (!self.sent_at && self.sent_at_changed?)
  end
end
