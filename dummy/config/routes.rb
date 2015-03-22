Rails.application.routes.draw do
  mount CommitFilter::Engine => "/rails/info"
end
