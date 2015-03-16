Rails.application.routes.draw do

  mount CommitFilter::Engine => "/commit_filter"
end
