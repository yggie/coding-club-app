class AppMailer < ActionMailer::Base
  default from: AppConfig.newsletter.sender
  layout 'app_mailer'

  def newsletter(newsletter, user)
    @newsletter = newsletter
    @user = user

    attachments.inline[Newsletter::HEADER_IMAGE_PATH] = File.read(Rails.root.join("app/assets/images/#{Newsletter::HEADER_IMAGE_PATH}"))
    mail(to: @user.email, subject: @newsletter.subject)
  end

  def newsletter_created_notification(newsletter, user)
    @newsletter = newsletter
    @user = user

    attachments.inline[Newsletter::HEADER_IMAGE_PATH] = File.read(Rails.root.join("app/assets/images/#{Newsletter::HEADER_IMAGE_PATH}"))
    mail(to: @user.email, subject: "A draft for #{@newsletter.target_date} has been created")
  end

  module Helper
    def newsletter_header_image_url
      attachments[Newsletter::HEADER_IMAGE_PATH].url
    end
  end

  helper Helper
end
