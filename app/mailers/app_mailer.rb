class AppMailer < ActionMailer::Base
  default from: AppConfig.newsletter.sender

  def send_newsletter(newsletter, group: raise)
    @newsletter = newsletter
    raise 'Attempted to send an invalid Newsletter' if @newsletter.invalid?

    attachments.inline['header.jpg'] = File.read(Rails.root.join("app/assets/images/#{Newsletter::HEADER_IMAGE_PATH}"))
    if group == :test
      mail(to: AppConfig.newsletter.recipient_groups.testers,
           subject: @newsletter.subject)
    else
      raise 'Not implemented!'
    end
  end

  module Helper
    def newsletter_header_image_url
      attachments['header.jpg'].url
    end
  end

  helper Helper
end
