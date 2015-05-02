require 'rails_helper'

describe NewslettersController, type: :controller do
  describe 'POST create', job: true do
    before(:each) do
      @subscribed_user = FactoryGirl.create(:user, subscription_preference: :subscribed)
      @admin_user = FactoryGirl.create(:user, subscription_preference: :admin)

      allow(request.env['warden']).to receive(:authenticate!) { @subscribed_user }
      allow(controller).to receive(:current_user) { @subscribed_user }

      @was_enabled = PaperTrail.enabled?
      PaperTrail.enabled = true
    end

    it 'requires authentication' do
      post :create, newsletter: { target_date: Date.tomorrow.to_s }

      expect(request.env['warden']).to have_received(:authenticate!)
    end

    it 'redirects the user to the newsletter page' do
      post :create, newsletter: { target_date: Date.tomorrow.to_s }

      expect(response).to redirect_to(newsletter_path(Newsletter.last))
    end

    it 'sends out notifications when a newsletter draft has been saved' do
      post :create, newsletter: { target_date: Date.tomorrow.to_s }

      expect(ActionMailer::Base.deliveries.map(&:to)).to match_array([
        [@admin_user.email],
      ])
    end

    after(:each) do
      PaperTrail.enabled = @was_enabled
      ActionMailer::Base.deliveries.clear
    end
  end
end
