class Newsletter < ActiveRecord::Base
  HEADER_IMAGE_PATH = 'mail-header.jpg'

  extend FriendlyId
  friendly_id :target_date, use: :slugged
  has_paper_trail only: [:subject, :body]

  validates :subject, presence: true
  validates :body, presence: true
  validates :target_date, presence: true

  scope :drafts, -> { where(sent_at: nil) }
  scope :archived, -> { where.not(sent_at: nil) }

  def readonly?
    (self.sent_at && !self.sent_at_changed?) || (!self.sent_at && self.sent_at_changed?)
  end
end
