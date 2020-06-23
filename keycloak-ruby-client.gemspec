
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "keycloak/version"

Gem::Specification.new do |spec|
  spec.name          = "keycloak-ruby-client"
  spec.version       = Keycloak::VERSION
  spec.authors       = ["Fuxin Hao"]
  spec.email         = ["haofxpro@gmail.com"]

  spec.summary       = %q{Keycloak ruby client}
  spec.description   = %q{Keycloak ruby client}
  spec.homepage      = "https://github.com/FX-HAO/keycloak-ruby-client"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org/"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/FX-HAO/keycloak-ruby-client"
    spec.metadata["changelog_uri"] = "https://github.com/FX-HAO/keycloak-ruby-client/blob/master/CHANGELOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 4.0"
  spec.add_dependency "rest-client", "~> 2.0"
  spec.add_dependency "concurrent-ruby", "~> 1.0"
  spec.add_dependency "jwt"
  spec.add_dependency "json-jwt"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "faker"
  spec.add_development_dependency "factory_bot"
end
