class AppMailer < ActionMailer::Base
  default from: AppConfig.newsletter.sender

  def prepare_newsletter(newsletter, user)
    @newsletter = newsletter
    @user = user
    raise 'Attempted to send an invalid Newsletter' if @newsletter.invalid?

    attachments.inline['header.jpg'] = File.read(Rails.root.join("app/assets/images/#{Newsletter::HEADER_IMAGE_PATH}"))
    mail(to: @user.email, subject: @newsletter.subject)
  end

  module Helper
    def newsletter_header_image_url
      attachments['header.jpg'].url
    end
  end

  helper Helper
end
