require 'spec_helper'

RSpec.describe Keycloak::API::UserResources do
  let(:user_rep) { build(:user_rep) }
  let(:role_rep) { build(:role_rep) }

  it 'create_user & find_users & update_user' do
    $client.create_user(user_rep)
    users = $client.find_users(username: user_rep.username).to_a
    expect(users.size).to eq(1)
    expect(users[0].username).to eq(user_rep.username)
    $client.update_user(users[0].id, Keycloak::Model::UserRepresentation.new(enabled: false))
    user = $client.find_user(users[0].id)
    expect(user.enabled).to eq(false)
  end

  context 'find users that have specified role name' do
    it 'realm role' do
      user_id = $client.create_user(user_rep)
      $client.create_role(role_rep)
      role = $client.find_role_by_name(role_rep.name)
      $client.add_role_mapping(user_id, [role])
      users = $client.find_user_by_role(role_rep.name).to_a
      expect(users.size).to eq(1)
      expect(users[0].id).to eq(user_id)
    end

    it 'client role' do
      client = $client.find_client_by_client_id('realm-management')
      user_id = $client.create_user(user_rep)
      role = $client.find_client_role_by_name(client.id, 'realm-admin')
      $client.add_client_role_mapping(user_id, client.id, [role])
      users = $client.find_user_by_client_role(client.id, role.name).to_a
      expect(users.size).to eq(1)
      expect(users[0].id).to eq(user_id)
    end
  end

end