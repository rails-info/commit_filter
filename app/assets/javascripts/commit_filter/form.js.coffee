jQuery ->
  $('#filter_repository_provider').change (event) ->
    event.preventDefault()
    
    if $(this).val() == 'plan.io'
      $('#plan_io_fields').show()
    else
      $('#plan_io_fields').hide()
      
    if $(this).val() == 'GitHub'
      $('#github_fields').show()
      $('#issue_url_field').hide()
    else
      $('#github_fields').hide()
      $('#issue_url_field').show()