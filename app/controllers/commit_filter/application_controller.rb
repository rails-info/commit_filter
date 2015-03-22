module CommitFilter
  class ApplicationController < ActionController::Base
    helper_method :framework_views_path, :commit_filter_stylesheets, :commit_filter_javascripts, :framework_presenter
  
    def self.framework_views_path
      "commit_filter/frameworks/#{CommitFilter.configuration.frontend_framework}"
    end
  
    def framework_views_path
      self.class.framework_views_path
    end
    
    def commit_filter_stylesheets
      @commit_filter_stylesheets || ['application', 'commit_filter/application']
    end
  
    def commit_filter_javascripts
      @commit_filter_javascripts || ['application']
    end
    
    private
    
    def framework_presenter
      @framework_presenter ||= CommitFilter::Presenters::Frameworks::TwitterBootstrap::Version3Presenter.new(
        self.view_context
      )
    end
  end
end
