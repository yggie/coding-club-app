class AppMailer < ActionMailer::Base
  default from: AppConfig.newsletter.sender

  def newsletter(newsletter, user)
    @newsletter = newsletter
    @user = user

    attachments.inline['header.jpg'] = File.read(Rails.root.join("app/assets/images/#{Newsletter::HEADER_IMAGE_PATH}"))
    mail(to: @user.email, subject: @newsletter.subject)
  end

  def newsletter_created_notification(newsletter, user)
    @newsletter = newsletter
    @user = user

    mail(to: @user.email, subject: "A draft for #{@newsletter.target_date} has been created")
  end

  module Helper
    def newsletter_header_image_url
      attachments['header.jpg'].url
    end
  end

  helper Helper
end
