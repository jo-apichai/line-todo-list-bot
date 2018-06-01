FactoryBot.define do
  factory :task do
    user_id { Faker::Lorem.characters(10) }
    description { Faker::Lorem.sentence }
    datetime { Faker::Time.forward(14, :all) }
  end
end