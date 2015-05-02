require 'rails_helper'

describe Event, :type => :model do
  subject(:event) { FactoryGirl.build_stubbed(:event) }

  it { is_expected.to allow_value(Date.tomorrow, Date.today).for(:date) }
  it { is_expected.not_to allow_value(Date.yesterday, 3.days.ago).for(:date) }
end
