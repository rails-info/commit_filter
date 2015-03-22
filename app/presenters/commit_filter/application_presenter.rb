class CommitFilter::ApplicationPresenter < CommitFilter::Presenter
  def flash_messages
    raise NotImplementedError
  end
  
  def form_field(filter, name, options = {})
    raise NotImplementedError
  end
end