require 'rails_helper'

describe Users::OmniauthCallbacksController, type: :controller do
  describe 'GET #google_oauth2' do
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @request.env['omniauth.auth'] = double(
        info: {
          email: 'someone@alliants.com',
          name: 'Some One',
          first_name: 'Some',
          last_name: 'One',
          image: 'http://image.url',
        }.as_json
      )
    end

    it 'creates a new user' do
      expect{
        get :google_oauth2
      }.to change{ User.count }.by(1)
    end

    it 'signs in the user' do
      get :google_oauth2
      expect(controller.current_user).to eq(User.last)
    end

    context 'with an existing user' do
      before(:each) do
        default_attributes = { email: @request.env['omniauth.auth'].info['email'] }
        @user = FactoryGirl.create(:user, default_attributes.merge(attributes))
        get :google_oauth2
      end

      context 'with a profile image' do
        let(:attributes) { { profile_image_url: 'http://some.url' } }


        it 'signs in the user' do
          expect(controller.current_user).to eq(@user)
        end
      end

      context 'without a profile image' do
        let(:attributes) { Hash.new }

        it 'overrides the existing attributes with the auth info' do
          attrs = controller.current_user.attributes.symbolize_keys
          expect(attrs.except(:created_at, :updated_at)).to eq({
            id: @user.id,
            subscription_preference: 1,
            email: 'someone@alliants.com',
            name: 'Some One',
            first_name: 'Some',
            last_name: 'One',
            profile_image_url: 'http://image.url',
          })
        end
      end
    end
  end
end
