# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'edr/version'

Gem::Specification.new do |gem|
  gem.name          = "edr"
  gem.version       = Edr::VERSION
  gem.authors       = ["Victor Savkin", "Matt Briggs", "Clemens Park", "Justin Fitzsimmons"]
  gem.email         = ["vsavkin@nulogy.com", "mbriggs@nulocy.com", "clemensp@nulogy.com", "justinf@nulogy.com"]
  gem.description   = %q{Entity Data-object Repository framework}
  gem.summary       = %q{Separate persistence from the domain model.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "activerecord", "~> 3.2.8"
  gem.add_development_dependency "sqlite3", "1.3.6"
  gem.add_development_dependency "database_cleaner", "~> 0.9.1"
  gem.add_dependency "orm_adapter", "~> 0.4.0"
end
