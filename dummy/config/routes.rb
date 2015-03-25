Rails.application.routes.draw do
  mount CommitFilter::Engine => "/"
end
