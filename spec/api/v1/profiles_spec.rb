require_relative '../../rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    def request(attributes = {})
      get '/api/v1/profiles/me', { format: :json }.merge(attributes)
    end

    it_behaves_like 'API should be authorization'

    context 'authorized' do
      let!(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { request(access_token: access_token.token) }

      it_behaves_like 'API success response'

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{ attr }" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path("user/#{attr}")
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{ attr }" do
          expect(response.body).to_not have_json_path("user/#{attr}")
        end
      end
    end
  end

  describe 'GET /profiles' do
    def request(attributes = {})
      get '/api/v1/profiles', { format: :json }.merge(attributes)
    end

    it_behaves_like 'API should be authorization'

    context 'authorized' do
      let(:me) { create(:user) }
      let!(:users) { create_list(:user, 2) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      before { request(access_token: access_token.token) }

      it_behaves_like 'API success response'

      %w(id email admin created_at updated_at).each do |attr|
        it "contains #{attr}" do
          users.each_with_index do |user, i|
            expect(response.body).to be_json_eql(user.send(attr.to_sym).to_json).at_path("profiles/#{i}/#{attr}")
          end
        end
      end

      %w(password encrypted_password).each do |attr|
        it "contains #{attr}" do
          users.each_with_index do |user, i|
            expect(response.body).to_not have_json_path("profiles/#{i}/#{attr}")
          end
        end
      end

      it 'does not return current user' do
        expect(response.body).to_not include_json(me.to_json)
      end
    end
  end
end