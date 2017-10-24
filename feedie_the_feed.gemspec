
require File.expand_path('../lib/feedie_the_feed/version', __FILE__)

Gem::Specification.new do |s|
  s.name    = 'feedie_the_feed'
  s.version = FeedieTheFeed::VERSION

  s.required_ruby_version = '>= 2.2'

  s.authors = ['Jerry Wisdom']
  s.email = ['krabique48@gmail.com']
  s.summary = 'A feed posts aggregator for rss and facebook pages'
  s.description = s.summary
  s.homepage = 'https://github.com/krabique48/feedie_the_feed'
  s.licenses = ['WTFPL']

  s.files = Dir.glob('lib/**/*') + %w[LICENSE README.md]
  s.require_path = 'lib'

  s.add_dependency 'feedjira',      '~> 2.1'
  s.add_dependency 'koala',         '~> 3.0'
  s.add_dependency 'public_suffix', '~> 3.0'
  s.add_dependency 'nesty',         '~> 1.0'

  s.add_development_dependency 'rspec', '~> 3.7'
end
