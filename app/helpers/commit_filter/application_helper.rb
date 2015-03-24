module CommitFilter
  module ApplicationHelper
    def form_field(*args, &block)
      framework_presenter.form_field *args, &block
    end
    
    def path_id(path)
      path.gsub(/\/|\./, '_')
    end
    
    def message_with_issue_urls(message)
      if @filter.issue_url.present?
        message.gsub(/#([0-9]+)/) do |s| 
          issue_url = @filter.issue_url.split(':id')
          s = s.gsub('#', '')
          issue_url = "#{issue_url[0]}#{s}#{issue_url[1]}"
          "<a href=\"#{issue_url}\">##{s}</a>"
        end
      else
        message
      end
    end
    
    def version_control_diff_link(path, rev)
      rev = params['rev'] || rev
      rev_to = params['rev_to'] || @filter.previous_revision_by_file[path]
     
      url = if rev == rev_to 
        if @filter.repository_provider == 'plan.io'
          "#{@filter.repository_host}/projects/#{@filter.project_slug}/repository/revisions/#{rev}/entry/#{path}"
        end
      else 
        "#{new_commit_diff_path}?repository_path=#{@filter.repository_path}&path=#{path}&rev=#{rev}&rev_to=#{rev_to}"
      end
      
      text = t('commit_filter.general.diff')
      
      if url.present?
        link_to text, url, class: 'diff commit_filter_diff_link'
      else
        text
      end
    end
    
    def annotate_file_link(text, rev, path, options = {})
      url = if @filter.repository_provider == 'plan.io'
        "#{@filter.repository_host}/projects/#{@filter.project_slug}/repository/revisions/#{rev}/annotate/#{path}"
      end
      
      text += " (your provider is not supported)" unless url.present?
      url = '#' unless url.present?
      link_to text, url, target: '_blank'
    end
  end
end
