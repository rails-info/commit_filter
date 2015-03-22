class CommitFilter::Presenter
  attr_accessor :view
  
  def initialize(working_view)
    self.view = working_view
  end
  
  private
  
  def method_missing(*args, &block)
    view.send(*args, &block)
  end
end