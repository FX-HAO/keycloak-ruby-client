require 'spec_helper'

RSpec.describe Keycloak::Model::BaseRepresentation do

  it 'to_json and as_json accept options' do
    attrs = {id: 1, username: 'haofuxin'}
    user_rep = Keycloak::Model::UserRepresentation.new(attrs)
    options = {only: [:id]}
    expect(user_rep.as_json(options)).to eq(attrs.as_json(options))
    expect(user_rep.to_json(options)).to eq(attrs.to_json(options))
  end

end