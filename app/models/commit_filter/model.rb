class CommitFilter::Model
  attr_accessor :workspace, :repository, :project_slug, :branch, :path, :author, :from, :to, :id
  attr_accessor :message, :story, :tasks, :filter_merges, :logger, :issue_url, :repository_provider, :repository_host
  attr_reader :errors, :commits_count, :last_revision, :first_revision, :previous_revision, :previous_revision_by_file
  
  def self.create(attributes = {})
    resource = new(attributes)
    
    if resource.valid?
      begin
        resource.files_by_category 
      rescue Grit::Git::GitTimeout
        @errors ||= {}
        @errors['base'] = I18n.t('commit_filter.filters.create.errors.too_many_git_timeouts')
      end
    end
    
    resource
  end
  
  def initialize(attributes = {})
    @commits_count, @previous_revision_by_file = 0, {}
    
    initialize_attributes(attributes)
    
    self
  end
  
  def repository_path; self.workspace.to_s + '/' + self.repository.to_s; end
  
  def valid?
    @valid = _valid? ? true : false
  end
  
  def files_by_category
    return {} unless valid?
    
    return @files_by_category if @files_by_category
    
    @files_by_category = { 
      library: { paths: [/^lib\//, /^app\/mailers\//] }, 
      model: { paths: [/^app\/models\//, /^db\//] }, 
      controller: { paths: [/^app\/controllers\//] }, 
      javascript: { paths: [/^app\/assets\/javascripts\//] },
      view: { 
        paths: [
          /^app\/assets\/stylesheets\//, /^app\/views\//, /^app\/helpers\//, /^app\/presenters\//,
          /^public\//
        ] 
      },
      tests: { paths: [/^spec\//, /^features\//] },
      configuration: { paths: [/^config\//] },
      misc: { paths: [] }
    }
  
    catch(:done) do
      commits do |page|
        page.each do |commit| 
          add_commit_to_files(commit) if commit_attributes_match_criteria?(commit)
        end
      end 
    end
    
    @files_by_category.each {|category, setting| @files_by_category.delete(category) unless setting[:files].try(:any?) }
    
    #get_previous_revision_for_files
    
    @files_by_category
  rescue Grit::NoSuchPathError
    @errors ||= {}
    @errors['base'] = I18n.t('commit_filter.filters.create.errors.repository_not_found')
  end
  
  def files_count; @previous_revision_by_file.keys.length; end
  
  private
  
  def initialize_attributes(attributes)
    default_attributes = { 
      'workspace' => CommitFilter.configuration.workspace,
      'repository' => CommitFilter.configuration.repository,
      'repository_provider' => CommitFilter.configuration.repository_provider,
      'repository_host' => CommitFilter.configuration.repository_host,
      'project_slug' => CommitFilter.configuration.project_slug,
      'branch' => CommitFilter.configuration.branch, 
      'issue_url' => CommitFilter.configuration.issue_url,
      'filter_merges' => CommitFilter.configuration.filter_merges 
    }
    
    if CommitFilter.configuration.workspace_and_repository_from_rails_root
      workspace = Rails.root.to_s.split('/')
      default_attributes['repository'] = workspace.pop
      default_attributes['workspace'] = workspace.join('/')
    end
    
    attributes = default_attributes.merge(attributes)
    attributes['filter_merges'] = false if attributes['filter_merges'].to_s == '0'
    attributes['to'] = 1.day.since.strftime('%Y-%m-%d') if attributes['from'].present? && attributes['to'].blank?
    
    attributes.each {|attribute, value| self.send("#{attribute}=", value) }
  end
  
  def _valid?
    @errors ||= {}
    
    ['workspace', 'repository', 'project_slug', 'branch'].each do |field|
      @errors[field] = I18n.t('commit_filter.filters.create.errors.cannot_be_blank') if self.send(field).blank?
    end  
    
    if path.blank? && author.blank? && id.blank? && message.blank? && story.blank? && tasks.blank? && from.blank? && to.blank?
      @errors['base'] = I18n.t('commit_filter.filters.create.errors.not_enough_criteria')
    end
    
    @errors.empty?
  end
  
  def repository_instance
    @repository_instance ||= Grit::Repo.new(self.repository_path)
  end
  
  def commits
    offset = 0
    
    if id.present?
      yield repository_instance.commits(id).select{|commit| commit.id == id }
    else
      while (page = try_two_times("Get commits from #{offset} to #{(offset + 100)}") { repository_instance.commits(self.branch, 100, offset) }).length > 0
        
        yield page
        
        offset += 100
      end
    end
  end
  
  def commit_attributes_match_criteria?(commit)
    if filter_merges && commit.message.match(/^Merge branch /)
      return false
    elsif commit.message.match(message) && (author.blank? || commit.author.name == author) && between_timespan?(commit.committed_date)
      return true
    else
      @previous_revision ||= commit.id
        
      throw :done if from.present? && Time.parse(from) > commit.committed_date
  
      false
    end
  end
  
  def add_commit_to_files(commit)
    @previous_revision = nil
    
    return if filter_merges && commit.message.match(/^Merge branch /)
    
    if commit.message.match(message) && (author.blank? || commit.author.name == author) && between_timespan?(commit.committed_date)
      @previous_revision = nil
    else
      @previous_revision ||= commit.id
      
      throw :done if from.present? && Time.parse(from) > commit.committed_date

      return
    end
    
    files = try_two_times("Commit(id: #{commit.id})#stats") { commit.stats }.files.map(&:first).select do |file_path|
      path.blank? || file_path.match(path)
    end
    
    return if files.none?
    
    @first_revision = commit.id
    @last_revision ||= commit.id
    @commits_count += 1
    
    files.each {|file_path| add_commit_to_file(file_path, commit) }
  end
  
  def between_timespan?(timestamp)
    return true if from.blank? && to.blank?
    
    from_valid = from.present? && Time.parse(from) <= timestamp
    to_valid = to.present? && Time.parse(to) >= timestamp
    
    valid = if from.present? && to.present? && from_valid && to_valid
      true
    elsif (from.blank? || to.blank?) && ((from.present? && from_valid) || (to.present? && to_valid))
      true
    else 
      false
    end
    
    valid
  end
  
  def add_commit_to_file(file_path, commit)
    category = :misc
            
    if file_path.match(/\//)
      @files_by_category.each do |current_category, setting|
        if setting[:paths].select{|part| file_path.match(part) }.any?  
          category = current_category; break
        end
      end
    else
      category = :configuration
    end
    
    if commit.parents.any?
      @previous_revision_by_file[file_path] = commit.parents.first.id  
    else
      # e.g. first commit has no parents
      @previous_revision_by_file[file_path] = nil
    end
    
    @files_by_category[category][:files] ||= {}
    @files_by_category[category][:files][file_path] ||= []
    @files_by_category[category][:files][file_path] << { 
      id: commit.id, committed_at: commit.committed_date.strftime('%d.%m.%Y %H:%M:%S'),
      message: commit.message, author: commit.author.name
    }
  end
  
  # alternative for Integer#tries to log try number and sleep between 
  def try_two_times(message = '')
    tries ||= 1
    
    if CommitFilter.configuration.git_debug_logging
      logger.info "#{Time.now.strftime('%H:%M:%S')} #{message} (try ##{tries})"
    end
    
    yield
  rescue Grit::Git::GitTimeout => e
    if (tries += 1) == 2
      sleep 2
      
      retry
    else
      raise e
    end
  end
end