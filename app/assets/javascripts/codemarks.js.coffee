$ ->
  $(".edit_codemark").click (e) ->
    e.preventDefault()
    $cm = $(e.target).closest('.codemark')
    url = $cm.find('.codemark_link').attr('href')
    id = $cm.find('#codemark_id').val()
    link_id = $cm.find('#link_id').val()
    $('#url').val(url)
    $('#resource_attrs_id').val(link_id)
    $('#id').val(id)
    $('#codemark_form').submit()
    $(window).scrollTop(0)
