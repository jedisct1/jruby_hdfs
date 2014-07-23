# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hdfs/version'

Gem::Specification.new do |gem|
  gem.name          = "jruby_hdfs"
  gem.version       = Hdfs::Version::STRING
  gem.authors       = ["Frank Falkenberg"]
  gem.email         = ["faltibrain@gmail.com"]
  gem.description   = %Q{HDFS API similar to Ruby's File API, one can use it as a drop-in replacement for files}
  gem.summary       = %Q{JRuby HDFS API similar to Ruby's File API}
  gem.homepage      = "https://github.com/jedisct1/jruby_hdfs"
  
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  if defined? JRUBY_VERSION
    gem.platform = "jruby"
  end
  
  gem.add_development_dependency "rake", "~> 0"
end
