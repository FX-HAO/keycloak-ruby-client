require 'spec_helper'

RSpec.describe Keycloak::Client do

  it 'obtain a new access token when the access token is expired' do
    old_access_token = $client.instance_variable_get(:@access_token)
    $client.instance_variable_set(:@expires_in, DateTime.now - 1.seconds)
    expect($client.access_token_expired?).to eq(true)
    $client.find_realm($client.realm)
    expect($client.instance_variable_get(:@access_token) != old_access_token).to eq(true)
    expect($client.access_token_expired?).to eq(false)
  end

  it 'obtain a new refresh token when the refresh token is expired' do
    old_refresh_token = $client.instance_variable_get(:@refresh_token)
    expired_time = DateTime.now - 1.seconds
    $client.instance_variable_set(:@expires_in, expired_time)
    $client.instance_variable_set(:@refresh_expires_in, expired_time)
    expect($client.access_token_expired?).to eq(true)
    expect($client.refresh_token_expired?).to eq(true)
    $client.find_realm($client.realm)
    expect($client.refresh_token_expired?).to eq(false)
    expect($client.access_token_expired?).to eq(false)
    expect($client.instance_variable_get(:@refresh_token) != old_refresh_token).to eq(true)
  end

end