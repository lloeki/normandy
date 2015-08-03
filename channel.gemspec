Gem::Specification.new do |s|
  s.name        = 'channel'
  s.version     = '0.1.0'
  s.licenses    = ['MIT']
  s.summary     = 'Channels'
  s.description = 'Share memory by communicating'
  s.authors     = ['Loic Nageleisen']
  s.email       = 'loic.nageleisen@gmail.com'
  s.files       = ['lib/channel.rb']
  s.homepage    = 'https://github.com/lloeki/channel'

  s.add_development_dependency 'pry'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'test-unit'
end
