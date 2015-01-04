require 'rails_helper'

describe SendNewsletterJob, type: :job do
  describe '.perform_later' do
    let(:admin_only) { false }

    before(:each) do
      @subscribed_user = FactoryGirl.create(:user, subscription_preference: :subscribed)
      @unsubscribed_user = FactoryGirl.create(:user, subscription_preference: :unsubscribed)
      @admin_user = FactoryGirl.create(:user, subscription_preference: :admin)

      @newsletter = FactoryGirl.create(:newsletter)
      SendNewsletterJob.perform_later(@newsletter, admin_only)
    end

    it 'sends the newsletter only to subscribed users' do
      expect(ActionMailer::Base.deliveries.map(&:to)).to match_array([
        [@subscribed_user.email],
        [@admin_user.email],
      ])
    end

    context 'with admin_only set to true' do
    let(:admin_only) { true }

      it 'sends the newsletter only to admin users' do
        expect(ActionMailer::Base.deliveries.map(&:to)).to match_array([
          [@admin_user.email],
        ])
      end
    end

    after(:each) do
      ActionMailer::Base.deliveries.clear
    end
  end
end
