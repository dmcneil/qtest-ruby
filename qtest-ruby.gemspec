# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qtest/version'

Gem::Specification.new do |spec|
  spec.name          = 'qtest-ruby'
  spec.version       = QTest::VERSION
  spec.authors       = ['Derek McNeil']
  spec.email         = ['derek.mcneil90@gmail.com']

  spec.summary       = 'A REST Client for the QTest API.'
  spec.homepage      = 'http://github.com/dmcneil/qtest-ruby'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'httparty', '~> 0.14'
  spec.add_dependency 'activesupport', '~> 5.0'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
