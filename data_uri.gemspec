# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'data_uri'
  s.version     = '0.0.3'
  s.author      = 'Donald Ball'
  s.email       = 'donald.ball@gmail.com'
  s.homepage    = 'http://github.com/dball/data_uri'
  s.description = 'URI class for parsing data URIs'
  s.summary     = 'A URI class for parsing data URIs as per RFC2397'

  s.required_ruby_version = '>= 2.6'

  s.platform = Gem::Platform::RUBY
  s.extra_rdoc_files = ['README.rdoc']

  s.require_path = 'lib'
  s.files = %w[README.rdoc Rakefile] + Dir.glob('lib/**/*')
end
