require 'spec_helper'

RSpec.describe Keycloak::API::RealmResources do

  it 'update_realm & find_realm' do
    $client.update_realm($client.realm, Keycloak::Model::RealmRepresentation.new(editUsernameAllowed: true))
    realm = $client.find_realm($client.realm)
    expect(realm.editUsernameAllowed).to eq(true)
  end

end