require 'spec_helper'

RSpec.describe Keycloak::API::UserResources do
  let(:user_rep) do
    Keycloak::Model::UserRepresentation.new(
      username: Faker::Internet.username,
      email: Faker::Internet.email,
      credentials: [
        Keycloak::Model::CredentialRepresentation.new(
          type: "password",
          temporary: false,
          value: Faker::Internet.password
        )
      ],
      enabled: true
    )
  end

  it 'create_user & find_users & update_user' do
    $client.create_user(user_rep)
    users = $client.find_users(username: user_rep.username).to_a
    expect(users.size).to eq(1)
    expect(users[0].username).to eq(user_rep.username)
    $client.update_user(users[0].id, Keycloak::Model::UserRepresentation.new(enabled: false))
    user = $client.find_user(users[0].id)
    expect(user.enabled).to eq(false)
  end

end