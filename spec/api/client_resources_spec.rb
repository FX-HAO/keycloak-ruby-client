require 'spec_helper'

RSpec.describe Keycloak::API::ClientResources do
  let(:client_rep) { build(:client_rep) }

  it 'create_client & update_client' do
    id_of_client = $client.create_client(client_rep)
    client_rep = $client.find_client_by_id(id_of_client)
    url = "https://www.google.com/"
    client_rep.baseUrl = url
    $client.update_client(id_of_client, client_rep)
    client = $client.find_client_by_id(id_of_client)
    expect(client.baseUrl).to eq(url)
  end

end