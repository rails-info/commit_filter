jQuery ->
  $('.file_commits input').change (event) ->
    event.preventDefault()
    
    fields = {}
    
    $.each $(this.form).serializeArray(), (index, field) ->
      fields[field.name] = field.value
      
    $.each $(this.form).find('a.diff'), (index, link) ->
      url = '#'
      
      if fields['rev'] == fields['rev_to'] 
        if repositoryProvider == 'plan.io'
          url = "#{repositoryHost}/projects/#{fields['project_slug']}/repository/revisions/#{fields['rev']}/entry/#{fields['path']}"
      else
        url = "#{diffPath}?repository_path=#{fields['repository_path']}&path=#{fields['path']}&rev=#{fields['rev']}&rev_to=#{fields['rev_to']}"
        
      $(link).attr('href', url)
      $(link).text("#{$(link).text()} (only supported for plan.io)")
  
  $(document.body).on 'click', '.commit_filter_diff_link', (event) ->
    event.preventDefault()
    url = $(this).attr('href')
    $('.modal-title').text $(this).text()
    $('.modal-body').html '<img src=\'' + spinnerImagePath + '\'/>'
    $('#modal').modal('show')  
    $('.modal-body').load url