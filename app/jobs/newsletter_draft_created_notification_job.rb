class NewsletterDraftCreatedNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(newsletter_id)
    newsletter = Newsletter.find(newsletter_id)

    User.admins.each do |admin|
      AppMailer.newsletter_created_notification(newsletter, admin).deliver_later
    end
  end
end
