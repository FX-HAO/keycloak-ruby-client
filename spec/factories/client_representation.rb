FactoryBot.define do
  factory :client_rep, class: Keycloak::Model::ClientRepresentation do
    name      { Faker::App.name }
    base_url  { Faker::Internet.url }
    enabled   { true }
  end
end