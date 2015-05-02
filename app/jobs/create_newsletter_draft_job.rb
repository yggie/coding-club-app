class CreateNewsletterDraftJob < ActiveJob::Base
  queue_as :default

  def perform(date)
    PaperTrail.whodunnit = self.class.to_s
    date_time = DateTime.parse(date)

    newsletter = Newsletter.draft(target_date: date_time)
    newsletter.save!

    NewsletterDraftCreatedNotificationJob.new.perform(newsletter.id)
  end
end
