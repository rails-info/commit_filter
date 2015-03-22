module CommitFilter
  class Engine < ::Rails::Engine
    isolate_namespace CommitFilter
    
     config.to_prepare do
       Rails.application.config.assets.precompile += %w(
         commit_filter/commit/diff.css
         commit_filter/file_commits.js
         commit_filter/frameworks/twitter_bootstrap/3/filter_result.js
       )
     end
  end
end
