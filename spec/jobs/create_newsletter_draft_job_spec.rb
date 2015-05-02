require 'rails_helper'

describe CreateNewsletterDraftJob, type: :job do
  describe '.perform_later' do
    let(:date) { (Time.now + 3.days).to_date }
    let(:date_string) { date.strftime('%Y-%m-%d') }

    before(:each) do
      Newsletter.delete_all
      @admin_one = FactoryGirl.create(:user, subscription_preference: :admin)
      @admin_two = FactoryGirl.create(:user, subscription_preference: :admin)
    end

    context 'with PaperTrail enabled' do
      before(:each) do
        @was_enabled = PaperTrail.enabled?
        PaperTrail.enabled = true
      end

      it 'creates a newsletter draft' do
        expect {
          CreateNewsletterDraftJob.perform_later(date_string)
        }.to change{ Newsletter.count }.by(1)
      end

      it 'sends notification emails to each admin' do
        CreateNewsletterDraftJob.perform_later(date_string)
        expect(ActionMailer::Base.deliveries.map(&:to)).to match_array([
          [@admin_one.email],
          [@admin_two.email],
        ])
      end

      it 'sets the newsletter target date to the specified date' do
        CreateNewsletterDraftJob.perform_later(date_string)
        expect(Newsletter.last.target_date).to eq(date)
      end

      it 'sets the originator of the create event to the job class name' do
        CreateNewsletterDraftJob.perform_later(date_string)
        expect(Newsletter.last.versions.last.whodunnit).to eq('CreateNewsletterDraftJob')
      end

      after(:each) do
        PaperTrail.enabled = @was_enabled
      end
    end
  end

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end
end
