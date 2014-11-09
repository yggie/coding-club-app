class AppMailer < ActionMailer::Base
  default from: AppConfig.newsletter.sender

  def send_newsletter(newsletter, group: raise)
    @newsletter = newsletter
    raise 'Attempted to send an invalid Newsletter' if @newsletter.invalid?

    @recipients = case group
                  when :test then AppConfig.newsletter.recipient_groups.testers
                  when :subscribed then AppConfig.newsletter.recipient_groups.subscribed
                  else raise 'Not implemented!'
                  end

    attachments.inline['header.jpg'] = File.read(Rails.root.join("app/assets/images/#{Newsletter::HEADER_IMAGE_PATH}"))
    mail(to: @recipients,
         subject: @newsletter.subject)
  end

  module Helper
    def newsletter_header_image_url
      attachments['header.jpg'].url
    end
  end

  helper Helper
end
