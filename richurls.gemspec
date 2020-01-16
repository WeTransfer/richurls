lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name = 'richurls'
  spec.version = '0.1.6'
  spec.authors = ['grdw']
  spec.email = ['gerard@wetransfer.com']

  spec.summary = 'Service which enriches URLs'
  spec.description = 'Service which enriches URLs fast and cheap'
  spec.homepage = 'https://github.com/wetransfer/richurls'
  spec.license = 'GPL-3.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/wetransfer/richurls'
  spec.metadata['changelog_uri'] = 'https://github.com/wetransfer/richurls/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added
  # into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'oj', '~> 3'
  spec.add_dependency 'ox', '~> 2'
  spec.add_dependency 'patron', '~> 0.13'
  spec.add_dependency 'redis', '~> 4.1'
  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'rubocop', '~> 0.79'
end
