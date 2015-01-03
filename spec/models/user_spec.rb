require 'rails_helper'

describe User, type: :model do
  subject(:user) { FactoryGirl.build_stubbed(:user) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:subscription_preference) }
  it { is_expected.to allow_value('email@alliants.com').for(:email) }
  it { is_expected.not_to allow_value('email@gmail.com', 'email@yahoo.com').for(:email) }

  context 'when the User is subscribed' do
    before(:each) { user.subscription_preference = :subscribed }

    it { is_expected.to be_subscribed }
    it { is_expected.not_to be_unsubscribed }
    it { is_expected.not_to be_admin }
  end

  context 'when the User has unsubscribed' do
    before(:each) { user.subscription_preference = :unsubscribed }

    it { is_expected.not_to be_subscribed }
    it { is_expected.to be_unsubscribed }
    it { is_expected.not_to be_admin }
  end

  context 'when the User has subscribed for admin newsletters' do
    before(:each) { user.subscription_preference = :admin }

    it { is_expected.to be_subscribed }
    it { is_expected.not_to be_unsubscribed }
    it { is_expected.to be_admin }
  end

  describe '.subscribed' do
    before(:each) do
      @default_user = FactoryGirl.create(:user)
    end

    it 'returns all the subscribed users' do
      expect(User.subscribed.to_a).to match_array([@default_user])
    end

    context 'with an unsubscribed user' do
      before(:each) do
        FactoryGirl.create(:user, subscription_preference: :unsubscribed)
      end

      it 'only does not return the unsubscribed users' do
        expect(User.subscribed.to_a).to match_array([@default_user])
      end
    end

    context 'with admin users' do
      before(:each) do
        @admin = FactoryGirl.create(:user, subscription_preference: :admin)
      end

      it 'also returns the admin users' do
        expect(User.subscribed.to_a).to match_array([@default_user, @admin])
      end
    end
  end
end
