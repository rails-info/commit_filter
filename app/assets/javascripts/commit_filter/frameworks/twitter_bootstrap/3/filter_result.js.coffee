jQuery ->
  $(document.body).on 'click', '.commit_filter_diff_link', (event) ->
    event.preventDefault()
    url = $(this).attr('href')
    $('.modal-title').text $(this).text()
    $('.modal-body').html '<img src=\'' + spinnerImagePath + '\'/>'
    $('#modal').modal('show')  
    $('.modal-body').load url