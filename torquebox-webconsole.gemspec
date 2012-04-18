# -*- encoding: utf-8 -*-
require File.expand_path('../lib/torquebox/webconsole/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ben Browning", "Tobias Crawley"]
  gem.email         = ["bbrowning@redhat.com", "tcrawley@redhat.com"]
  gem.description   = %q{Extends rack-webconsole to allow switching between TorqueBox app runtimes.}
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/torquebox/torquebox-webconsole"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "torquebox-webconsole"
  gem.require_paths = ["lib"]
  gem.version       = Torquebox::Webconsole::VERSION

  gem.add_runtime_dependency 'rack-webconsole', '0.1.3'
end
