# Keycloak::Ruby::Client

This is a keycloak client implementation in ruby. I mainly use this in a rails project, so this is 
written with some methods that derive from rails.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'keycloak-ruby-client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install keycloak-ruby-client

## Usage

Firstly, you need to register your keycloak config:

```ruby
Keycloak::Realm.register do |config|
  config.installation_file = Rails.root.join("config/keycloak.json")
end
```

or 

```ruby
Keycloak::Realm.register do |config|
  config.auth_server_url = "http://127.0.0.1:8081/auth"
  
  config.realm = "shundao-admin"
end
```

Then you can authenticate your keycloak JWT token:

```ruby
token = "your_bearer_token"
keycloak_token = Keycloak::Realm.shundao_admin.parse_access_token(token) # an instance of Keycloak::AccessToken
raise CanCan::AccessDenied if keycloak_token.expired? || !keycloak_token.has_role?("admin")

# authentication succeeded 
```

Or you may need asking if permissions are granted from keycloak server, it's also worth noting that 
this is much expensive than decoding JWT cuz this asks from keycloak server every time. 
Always use JWT unless there is a compelling reason to use this.

```ruby
token = "your_bearer_token"
keycloak_token = Keycloak::Realm.shundao_admin.parse_access_token(token)
raise Cancan::AccessDenied unless Keycloak::Realm.shundao_admin.client.granted_by_server("Admin Resources#view", keycloak_token)

# authentication succeeded
```

Some examples demonstrate how to interact with Keycloak admin REST API:

```ruby
admin_username = ENV['KEYCLOAK_USERNAME'] || 'admin'
admin_password = ENV['KEYCLOAK_PASSWORD'] || 'admin'
auth_server_url = ENV['KEYCLOAK_SERVER_URL'] || 'http://127.0.0.1:8081/auth'
realm = 'shundao-admin'

# authenticate
client = Keycloak::Client.new(auth_server_url, realm)
client.authenticate(admin_username, admin_password, "password", "admin-cli", "master")

# create the roles
role_store = {}
roles = ['user', 'premium', 'admin']
roles.each do |role|
  role_rep = Keycloak::Model::RoleRepresentation.new({
    name: role
  })
  role_store[role] = client.create_or_find_role(role_rep)
end

# create a user with the roles created above
user_rep = Keycloak::Model::UserRepresentation.new({
  username: "alice",
  credentials: [
    Keycloak::Model::CredentialRepresentation.new({
      type: "password",
      temporary: false,
      value: '123456'
    })
  ],
  enabled: true,
  requiredActions: ['UPDATE_PASSWORD']
})
mapping_roles = role_store.map { |entry| {id: entry[1].id , name: entry[1].name} }
client.create_user(user_rep, mapping_roles)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/FX-HAO/keycloak-ruby-client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Keycloak::Ruby::Client project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/FX-HAO/keycloak-ruby-client/blob/master/CODE_OF_CONDUCT.md).
