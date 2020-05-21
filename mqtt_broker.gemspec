require_relative 'lib/mqtt_broker/version'

Gem::Specification.new do |spec|
  spec.name          = "mqtt_broker"
  spec.version       = MqttBroker::VERSION
  spec.authors       = ["scope2229"]
  spec.email         = ["kaine_76@hotmail.com"]

  spec.summary       = "Simple MQTT Broker/Server in Ruby"
  spec.description   = "If linked with Rails it should be spawned in its own process away from rails to prevent bottle-necking"
  spec.homepage      = "https://www.github.com/scope2229/mqtt_broker"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://www.github.com/scope2229/mqtt_broker"
  spec.metadata["changelog_uri"] = "#{spec.metadata["source_code_uri"]}/CHANGELOG"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  if Gem.ruby_version >= Gem::Version.new('2.7.0')
    spec.add_development_dependency 'rake', '~> 12.0'
    spec.add_development_dependency 'rspec', '~> 3.5.0'
    spec.add_development_dependency 'guard-rspec', '~> 4.7.3'
  else
    raise "#{Gem.ruby_version} is an unsupported version of ruby"
  end
end
