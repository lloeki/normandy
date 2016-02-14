Gem::Specification.new do |s|
  s.name        = 'normandy'
  s.version     = '0.1.0'
  s.licenses    = ['MIT']
  s.summary     = 'Channels, CSP style'
  s.description = 'Share memory by communicating'
  s.authors     = ['Loic Nageleisen']
  s.email       = 'loic.nageleisen@gmail.com'
  s.files       = Dir['lib/**/*.rb']
  s.homepage    = 'https://github.com/lloeki/normandy'

  s.add_development_dependency 'pry'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'test-unit'
end
