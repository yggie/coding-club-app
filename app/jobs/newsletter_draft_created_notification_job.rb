class NewsletterDraftCreatedNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(newsletter_id)
    newsletter = Newsletter.find(newsletter_id)

    User.admins.each do |admin|
      # TODO deliver_later does not seem to play well with rake tasks
      AppMailer.newsletter_created_notification(newsletter, admin).deliver_now
    end
  end
end
