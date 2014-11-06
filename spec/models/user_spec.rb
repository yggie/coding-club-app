require 'rails_helper'

describe User, type: :model do
  subject(:user) { FactoryGirl.build_stubbed(:user) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to allow_value('email@alliants.com').for(:email) }
  it { is_expected.not_to allow_value('email@gmail.com', 'email@yahoo.com').for(:email) }
end
