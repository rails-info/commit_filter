class CommitFilter::Commit::DiffsController < CommitFilter::ApplicationController
  def new
    repository = Grit::Repo.new(params[:repository_path])

    diff = repository.diff(
      repository.commit(params[:rev_to]), repository.commit(params[:rev]), params[:path]
    )
    
    unless diff.length == 1
      raise NotImplementedError.new(
        t('commit_filter.diff.errors.diff_length_not_one', length: diff.length)
      )
    end
    
    render text: DiffToHtml::GitConverter.new.get_single_file_diff_body(diff.first.diff)
  rescue Exception => e
    if Rails.env.development?
      raise e.class.name + ': ' + e.message + ' ... ' + e.backtrace.join("\n")
    else
      logger.error e.class.name + ': ' + e.message + ' ... ' + e.backtrace.join("\n")
      render text: t('commit_filter.general.errors.internal_server_error')
    end
  end
end