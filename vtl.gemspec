Gem::Specification.new do |s|
  s.name        = 'vtl'
  s.version     = '1.0.0'
  s.date        = '2015-07-07'
  s.summary     = "VTL parser"
  s.description = "VTL parser library"
  s.authors     = [ "Aleksey Gureiev" ]
  s.email       = 'spyromus@noizeramp.com'
  s.homepage    = 'http://rubygems.org/gems/vtl'
  s.license     = 'MIT'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency "nokogiri"
  s.add_dependency "timeliness"
  s.add_dependency "hashie"

  s.add_development_dependency "guard"
  s.add_development_dependency "guard-minitest"
end
