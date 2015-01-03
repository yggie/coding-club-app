require 'rails_helper'

describe AppMailer, type: :mailer do
  describe '.prepare_newsletter' do
    let(:newsletter) { FactoryGirl.build_stubbed(:newsletter) }
    let(:user) { FactoryGirl.build_stubbed(:user) }

    it 'does not raise an exception' do
      expect {
        AppMailer.prepare_newsletter(newsletter, user)
      }.not_to raise_exception
    end
  end
end
