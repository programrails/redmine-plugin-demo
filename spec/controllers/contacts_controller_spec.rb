require __dir__.split('spec').first + 'spec/rails_helper'

RSpec.describe ContactsController, type: :controller do
  describe 'Testing full access' do
    before(:each) do
      admin = create(:admin)

      @request.session[:user_id] = admin.id
    end

    describe 'GET #index' do
      it 'returns a success response' do
        get :index
        expect(response).to be_success
      end

      it 'returns all contacts' do
        contact1 = create(:contact1)
        contact2 = create(:contact2)

        get :index
        expect(assigns(:contacts)).to match_array([contact1, contact2])
      end

      it 'renders the :index template' do
        get :index
        expect(response).to render_template :index
      end
    end
  end
end
