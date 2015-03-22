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
  
  # misc
  s.add_dependency 'gem_config', '~> 0.3.1'
  
  # model
  s.add_dependency 'sqlite3', '~> 1.3.10'
  s.add_dependency 'gitlab-grit', '~> 2.7.3'
  
  # view
  s.add_dependency 'coffee-script', '~> 2.3.0'
  s.add_dependency 'jquery-rails', '~> 4.0.3'
  s.add_dependency 'diff_to_html', '~> 0.0.1'
  s.add_dependency 'pygments.rb', '~> 0.6.2'
end
