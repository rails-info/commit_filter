$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'commit_filter/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'commit_filter'
  s.version     = CommitFilter::VERSION
  s.authors     = ['Mathias Gawlista']
  s.email       = ['gawlista@gmail.com']
  s.homepage    = 'http://GitHub.com/volontarian/commit_filter'
  s.summary     = 'Rails engine which renders a view about (Git) commits with given criteria grouped by category (library, model, controller, javascript, view, configuration and misc) and file name.'
  s.description = '#Ruby on #Rails engine which renders a view about (#Git) commits with given criteria grouped by category (e.g. model) and file name.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 4.2.0'
end
