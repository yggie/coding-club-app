require 'rails_helper'

describe AppMailer, type: :mailer do
  describe '.newsletter' do
    let(:newsletter) { FactoryGirl.build_stubbed(:newsletter) }
    let(:user) { FactoryGirl.build_stubbed(:user) }

    it 'does not raise an exception' do
      expect {
        AppMailer.newsletter(newsletter, user)
      }.not_to raise_exception
    end
  end

  describe '.newsletter_created_notification' do
    let(:newsletter) { FactoryGirl.build_stubbed(:newsletter) }
    let(:user) { FactoryGirl.build_stubbed(:user, subscription_preference: :admin) }

    it 'does not raise an exception' do
      expect {
        AppMailer.newsletter_created_notification(newsletter, user)
      }.not_to raise_exception
    end
  end
end
