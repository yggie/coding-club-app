class Newsletter < ActiveRecord::Base
  HEADER_IMAGE_PATH = 'header_transparent_bg_2015.png'

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

  def recent_activities(num)
    versions.last(num).reverse.map do |raw_version|
      Activity.new(raw_version)
    end
  end

  def total_activities
    versions.count
  end

  # TODO doesn’t really belong here, but will do for now
  def due_date_in_words
    day_diff = ((target_date.beginning_of_day - Time.now.beginning_of_day)/1.day).to_i

    if day_diff > 1
      "Draft due in #{day_diff} days"
    elsif day_diff <= 0
      'Draft overdue'
    else
      'Draft is due tomorrow'
    end
  end

  class Activity
    def initialize(raw_version)
      @raw_version = raw_version
    end

    def user
      @user ||= case @raw_version.whodunnit
                  when /\A\d+\z/
                    User.find(@raw_version.whodunnit)

                  when 'CreateNewsletterDraftJob'
                    # TODO convert to NullUser
                    OpenStruct.new(
                      profile_image_url: 'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mm&f=y&s=50',
                      name: 'Coding Club App',
                    )
                end
    end

    def type
      @raw_version.event
    end

    def time
      @raw_version.created_at
    end
  end
end
