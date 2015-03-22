# misc
require 'gem_config'
require 'grit'

# view
require 'jquery-rails'
require 'coffee_script'
require 'diff_to_html'
require 'pygments'

require 'commit_filter/grit_extension'

require 'commit_filter/engine'

module CommitFilter
  include GemConfig::Base

  with_configuration do
    has :frontend_framework, classes: String, values: ['twitter_bootstrap/3'], default: 'twitter_bootstrap/3'
    has :workspace_and_repository_from_rails_root, classes: [TrueClass, FalseClass], default: true
    has :workspace, classes: String
    has :repository, classes: String
    has :repository_provider, classes: String
    has :repository_host, classes: String
    has :project_slug, classes: String
    has :branch, classes: String, default: 'master'
    has :issue_url, classes: String
    has :filter_merges, classes: [TrueClass, FalseClass], default: true
    has :git_debug_logging, classes: [TrueClass, FalseClass], default: false
  end
end
