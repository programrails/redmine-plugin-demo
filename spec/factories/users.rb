FactoryBot.define do
  factory :user do
    password '12345678'
    password_confirmation '12345678'

    factory :admin do
      login 'admin'
      admin true
      firstname 'admin'
      lastname 'admin'
      mail 'admin@example.com'
    end
  end
end
