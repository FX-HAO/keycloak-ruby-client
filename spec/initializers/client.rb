admin_username = ENV['KEYCLOAK_USERNAME'] || 'admin'
admin_password = ENV['KEYCLOAK_PASSWORD'] || 'admin'
auth_server_url = ENV['KEYCLOAK_SERVER_URL'] || 'http://127.0.0.1:8081/auth'

data = JSON.parse(File.read(File.join(File.dirname(__FILE__), '../config/keycloak.json')))

$client = Keycloak::Client.new(auth_server_url, data["realm"])
$client.authenticate(admin_username, admin_password, "password", "admin-cli", "master")

$client.create_realm(Keycloak::Model::RealmRepresentation.new(id: $client.realm, realm: $client.realm, enabled: true)) rescue RestClient::Conflict


RSpec.configure do |config|
  config.after(:suite) do
    $client.delete_realm($client.realm)
  end
end
