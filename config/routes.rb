CommitFilter::Engine.routes.draw do
  namespace :commit do
    resources :filters, only: [:new, :create]
    resources :diffs, only: [:new]
  end
end
