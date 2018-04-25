require __dir__.split('spec').first + 'spec/rails_helper'

RSpec.describe Contact, type: :model do
  it 'makes sure RSpec generally works for Redmine plugins' do
    contact = FactoryBot.build(:contact)
    expect(contact.full_name).to eq 'Contact'
  end
end
