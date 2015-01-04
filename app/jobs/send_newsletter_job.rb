class SendNewsletterJob < ActiveJob::Base
  queue_as :default

  def perform(newsletter, admin_only=false)
    # TODO rescue errors if any?
    users = admin_only ? User.admins : User.subscribed
    users.each do |user|
      AppMailer.newsletter(newsletter, user).deliver_later
    end
  end
end
