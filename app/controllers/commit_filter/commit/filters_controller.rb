class CommitFilter::Commit::FiltersController < CommitFilter::ApplicationController
  layout "#{CommitFilter::ApplicationController.framework_views_path}/layouts/commit_filter/application"
  
  def new
    params[:filter] ||= {}
    @filter = CommitFilter::Model.new(params[:filter].merge(logger: logger))
    @commit_filter_javascripts = ['application', 'commit_filter/form']
    
    render "#{framework_views_path}/commit/filters/new"
  end

  def create
    params[:filter] ||= {}
    @filter = CommitFilter::Model.create(params[:filter].merge(logger: logger))
    
    if @filter.valid? && @filter.last_revision.blank?
      flash[:alert] = I18n.t('commit_filter.filters.create.errors.nothing_found')
    end
    
    @commit_filter_stylesheets = ['application', 'commit_filter/application', 'commit_filter/commit/diff']
    @commit_filter_javascripts = [
      'application', 'commit_filter/form', 'commit_filter/file_commits', 
      "#{CommitFilter::ApplicationController.framework_views_path}/filter_result"
    ]
    
    render "#{framework_views_path}/commit/filters/new"
  end
end