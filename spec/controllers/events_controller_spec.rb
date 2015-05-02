require 'rails_helper'

describe EventsController, type: :controller do
  describe 'POST create' do
    before(:each) do
      allow(request.env['warden']).to receive(:authenticate!) { @subscribed_user }
      allow(controller).to receive(:current_user) { @subscribed_user }
    end

    it 'requires authentication' do
      post :create, event: FactoryGirl.attributes_for(:event)

      expect(request.env['warden']).to have_received(:authenticate!)
    end

    it 'sends notification emails to every admin' do
      FactoryGirl.create(:user, subscription_preference: :subscribed)
      admin_user = FactoryGirl.create(:user, subscription_preference: :admin)
      post :create, event: FactoryGirl.attributes_for(:event)

      expect(ActionMailer::Base.deliveries.map(&:to)).to match_array([
        [admin_user.email],
      ])
    end

    it 'sends a notification email to the host' do
      subscribed_user = FactoryGirl.create(:user, subscription_preference: :subscribed)
      post :create, event: FactoryGirl.attributes_for(:event, user_id: subscribed_user.id)

      expect(ActionMailer::Base.deliveries.map(&:to)).to match_array([
        [subscribed_user.email],
      ])
    end

    after(:each) do
      ActionMailer::Base.deliveries.clear
    end
  end


  describe 'PATCH update', job: true do
    before(:each) do
      allow(request.env['warden']).to receive(:authenticate!) { @subscribed_user }
      allow(controller).to receive(:current_user) { @subscribed_user }

      @event = FactoryGirl.create(:event)
    end

    it 'requires authentication' do
      post :update, id: @event.id, event: { date: Date.tomorrow.to_s }

      expect(request.env['warden']).to have_received(:authenticate!)
    end

    it 'sends a notification email to the new host' do
      subscribed_user = FactoryGirl.create(:user, subscription_preference: :subscribed)
      patch :update, id: @event.id, event: { user_id: subscribed_user.id }

      expect(ActionMailer::Base.deliveries.map(&:to)).to match_array([
        [subscribed_user.email],
      ])
    end

    it 'does not send a notification email if the host has not changed' do
      subscribed_user = FactoryGirl.create(:user, subscription_preference: :subscribed)
      @event.update_attributes(user_id: subscribed_user.id)
      patch :update, id: @event.id, event: { user_id: subscribed_user.id }

      expect(ActionMailer::Base.deliveries.map(&:to)).to be_empty
    end

    after(:each) do
      ActionMailer::Base.deliveries.clear
    end
  end
end
