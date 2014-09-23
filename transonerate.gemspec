# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require File.expand_path('../lib/transonerate/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'transonerate'
  gem.authors       = [ "Richard Smith-Unna", "Chris Boursnell" ]
  gem.email         = "rds45@cam.ac.uk"
  gem.licenses      = ["MIT"]
  gem.homepage      = 'https://github.com/cboursnell/transonerate'
  gem.summary       = "Assessment of assembly quality by aligning to a genome"
  gem.description   = "Assessment of assembly quality by aligning to a genome with exonerate"
  gem.version       = Transonerate::VERSION::STRING.dup

  gem.files = `git ls-files`.split("\n")
  gem.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = %w( lib )

  gem.add_dependency 'trollop', '~> 2.0'
  gem.add_dependency 'bindeps', '~> 0.1', '>= 0.1.0'
  gem.add_dependency 'threach', '~> 0.2', '>= 0.2.0'

  gem.add_development_dependency 'rake', '~> 10.3', '>= 10.3.2'
  gem.add_development_dependency 'turn', '~> 0.9', '>= 0.9.7'
  gem.add_development_dependency 'minitest', '~> 4', '>= 4.7.5'
  gem.add_development_dependency 'simplecov', '~> 0.8', '>= 0.8.2'
  gem.add_development_dependency 'shoulda-context', '~> 1.2', '>= 1.2.1'
  gem.add_development_dependency 'coveralls', '~> 0.7'
end
