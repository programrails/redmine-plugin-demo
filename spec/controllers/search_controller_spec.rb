require __dir__.split('spec').first + 'spec/rails_helper'

RSpec.describe SearchController, type: :controller do
  before(:each) do
    admin = create(:admin)

    @request.session[:user_id] = admin.id
  end

  describe 'GET #search' do
    it 'finds a contact by keyword' do
      contact1 = create(:contact1)
      get :index, q: contact1.full_name, contacts: '1'
      expect(assigns(:results).first.full_name).to eq contact1.full_name
    end
  end
end
