FactoryBot.define do
  factory :role_rep, class: Keycloak::Model::RoleRepresentation do
    name    { Faker::Hacker.abbreviation }
  end
end