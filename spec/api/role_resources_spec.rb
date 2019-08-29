require 'spec_helper'

RSpec.describe Keycloak::API::RoleResources do
  let(:role_rep) do
    Keycloak::Model::RoleRepresentation.new(
      name: Faker::Hacker.abbreviation
    )
  end

  it 'create_role & find_role_by_name' do
    $client.create_role(role_rep)
    role = $client.find_role_by_name(role_rep.name)
    expect(role_rep.name).to eq(role.name)
  end

end