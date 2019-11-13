FactoryBot.define do
  factory :user_rep, class: Keycloak::Model::UserRepresentation do
    username    { Faker::Internet.username }
    email       { Faker::Internet.email }
    credentials do
      [
        Keycloak::Model::CredentialRepresentation.new(
          type: "password",
          temporary: false,
          value: Faker::Internet.password
        )
      ]
    end
    enabled     { true }
  end
end