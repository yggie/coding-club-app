class NotifyEventCreatedJob < ActiveJob::Base
  queue_as :default

  def perform(event_id)
    event = Event.find(event_id)

    users_to_notify = User.admins.to_a

    if event.user && !users_to_notify.include?(event.user)
      users_to_notify << event.user
    end

    users_to_notify.each do |user|
      if user == event.user
        AppMailer.event_created_for_you_notification(event, user).deliver_now
      else
        AppMailer.event_created_notification(event, user).deliver_now
      end
    end
  end
end
