class CreateNewsletterDraftJob < ActiveJob::Base
  queue_as :default

  def perform(date)
    PaperTrail.whodunnit = self.class.to_s
    date_time = DateTime.parse(date)

    newsletter = Newsletter.create!(
      target_date: date_time,
      subject: 'This Week',
      body: <<-MARKDOWN
# Welcome to this week's Coding Club

*****************************

# This’s Week’s Talk
[Details of the talk]

*****************************

# What People are up to

## [Person]
[What “Person” is planning to do]

*****************************

Closing remarks

*Alliants Coding Club Committee*
      MARKDOWN
    )

    User.admins.each do |admin|
      # TODO deliver_later does not seem to play well with rake tasks
      AppMailer.newsletter_created_notification(newsletter, admin).deliver_now
    end
  end
end
