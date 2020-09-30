# frozen_string_literal: true
#!/usr/bin/env ruby -rubygems

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'mqtt/version'

Gem::Specification.new do |spec|
  spec.name          = 'mqtt'
  spec.version       = MQTT::VERSION
  spec.authors       = ['scope2229']
  spec.email         = ['kaine_76@hotmail.com']

  spec.summary       = 'Simple MQTT Server in Ruby'
  spec.description   = 'If linked with Rails it should be spawned in its own process away from rails to prevent bottle-necking'
  spec.homepage      = 'https://www.github.com/scope2229/mqtt_server'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.7.1')

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://www.github.com/scope2229/mqtt_server'
  spec.metadata['changelog_uri'] = "#{spec.metadata['source_code_uri']}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  # spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
  #   `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  # end
  spec.files = Dir['{lib}/**/*', 'CHANGELOG.md', 'MIT-LICENSE', 'README.md']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  if Gem.ruby_version >= Gem::Version.new('2.7.0')
    spec.add_development_dependency 'bundler', '~> 2.1.2'
    spec.add_development_dependency 'guard-rspec', '~> 4.7.3'
    spec.add_development_dependency 'pry', '~> 0.13.1'
    spec.add_development_dependency 'rake', '~> 13.0.1'
    spec.add_development_dependency 'rspec', '~> 3.5.0'
  else
    raise "#{Gem.ruby_version} is an unsupported version of ruby"
  end
end
