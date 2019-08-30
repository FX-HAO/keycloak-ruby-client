require 'spec_helper'

RSpec.describe Keycloak::Model::UserRepresentation do

  it 'support both camel-style and snake-style fields' do
    user_rep = Keycloak::Model::UserRepresentation.new required_actions: [], clientRoles: []
    expect(user_rep.requiredActions).to eq([])
    expect(user_rep.client_roles).to eq([])
  end

end