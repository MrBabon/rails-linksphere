require 'rails_helper'

RSpec.describe UserContactGroupsController, type: :controller do
  describe 'GET #show' do
    let(:user) { create(:user) }
    let(:repertoire) { create(:repertoire, user: user) }
    let(:contact_group) { create(:contact_group, repertoire: repertoire) }
    let(:user_contact_group) { create(:user_contact_group, repertoire: repertoire, user: user) }
    let(:entreprise) { create(:entreprise, owner: user) }
    let(:employee) { create(:employee, user: user) }

    before do
      sign_in user
    end

    context 'when user is in the repertoire' do
      before do
        get :show, params: { id: user.id }
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the serialized user' do
        expect(response.body).to include(UserSerializer.new(user).serializable_hash.to_json)
      end

      it 'returns the serialized contact groups' do
        expect(response.body).to include(ContactGroupSerializer.new([contact_group]).serializable_hash.to_json)
      end

      it 'returns the serialized user contact group' do
        expect(response.body).to include(UserContactGroupSerializer.new(user_contact_group).serializable_hash.to_json)
      end

      it 'returns the serialized entreprise if user is an entrepreneur' do
        user.update(entrepreneurs: true)
        user.entreprises_as_owner << entreprise
        get :show, params: { id: user.id }
        expect(response.body).to include(EntrepriseSerializer.new(entreprise).serializable_hash.to_json)
      end

      it 'returns the serialized employee if user has employee relationships' do
        user.update(employee_relationships: true)
        user.entreprises_as_employee << employee
        get :show, params: { id: user.id }
        expect(response.body).to include(EmployeeSerializer.new(employee).serializable_hash.to_json)
      end
    end

    context 'when user is not in the repertoire' do
      before do
        get :show, params: { id: user.id }
      end

      it 'returns a forbidden response' do
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns an error message' do
        expect(response.body).to include('Access denied because this user is not in your directory.')
      end
    end
  end
end