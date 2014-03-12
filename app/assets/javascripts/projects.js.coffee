window.Project =
  search: ()->
    search_name = $('#search_name').val()
    industry = $('.industry').find('.active a').attr('data-id')
    district = $('.district').find('.active a').attr('data-id')
    $.get '/projects_searcher/index', { search_name: search_name, industry: industry, district: district }, (data)->
      $('.projects_search').html(data)

$(document).ready ->
  $('.selection a, .industry a, .district a').click (e)->
    e.preventDefault()
    $(this).parent().addClass('active')
    $(this).parent().siblings().removeClass('active')
    Project.search()

  $('#search_button').click (e)->
    e.preventDefault()
    Project.search()

  # 回车注册
  $('#search_name').keyup (e)->
    if e.keyCode == 13
      $('#search_button').click()

  # 添加一个成员
  $('a.add_member').click (e)->
    e.preventDefault()
    url = $(this).attr('href')
    $.get url, (data)->
      $('.add_member_section').html(data)
      # 自动完成绑定
      $('#member_user_name').autocomplete(
        source: (request, response)->
          console.log(request.term)
          $.get "/users/autocomplete", search: request.term, (data)->
            if data.success
              response $.map(data['data'], (item)->
                {
                  user_id: item.id,
                  value: item.name,
                })
            else
              Alert.fail(data.message)
        ,
        minLength: 1,
        select: (event, ui)->
          $('#member_user_id').val( ui.item.user_id )
          $('#member_user_id').data('name', ui.item.value)
        close: (event, ui)->
          if $('#member_user_id').data('name') != $('#member_user_name').val()
            $('.member_user_email').removeClass('hide')
          else
            $('.member_user_email').addClass('hide')
          
      )
      $('#member_user_name').blur (e)->
        return if $(this).val() == ''
        if $('#member_user_id').data('name') != $('#member_user_name').val()
          $('.member_user_email').removeClass('hide')
          $('.member_user_email input').focus()
        else
          $('.member_user_email').addClass('hide')


  $(this).on 'click', '.add_member_button', (e)->
    e.preventDefault()

    # 处理选中时的情况
    if $('#member_user_id').val() && $('#member_user_id').data('name') == $('#member_user_name').val()
      params = {
        user_id: $('#member_user_id').val(),
        role: $('#member_role').val()
      }
    else
      #未选中
      params = {
        name: $('#member_user_name').val(),
        email: $('#member_user_email').val(),
        role: $('#member_role').val(),
      }
    url = $('.add_member_div').data('uri')
    $.post url, params, (data)->
      Alert.doit data, ()->
        url = $('div.members').data('uri')
        $.get url, (data)->
          $('div.members').html(data)
        $('.add_member_section').empty()

  # 取消
  $(this).on 'click', '#cancel_member', (e)->
    e.preventDefault()
    $('.add_member_section').empty()
    

  $('#publish').click (e)->
      e.preventDefault()
      if confirm_data = $(this).data('confirm')
        return unless window.confirm( confirm_data )
      $.post $(this).data('uri'), (data)->
        Alert.doit data, ->
          window.location.reload()
    
  $('#new_money_require').submit (e)->
    e.preventDefault()
    $.post $(this).attr('action'), $(this).serialize(), (data)->
      Alert.doit data, ->
        $('#invest-modal').foundation('reveal', 'close')
        $('.syndicate_info').fadeOut 'slow', ->
          $(this).html(data)
          $(this).fadeIn('slow')

  $('#new_person_require').submit (e)->
    e.preventDefault()
    $.post $(this).attr('action'), $(this).serialize(), (data)->
      Alert.doit data, ->
        $('#invite-modal').foundation('reveal', 'close')
        #TODO 局部刷新即可
        window.location.reload()

  $('#new_investment').submit (e)->
    e.preventDefault()
    $.post $(this).attr('action'), $(this).serialize(), (data)->
      ALert.doit data, ->
        $('#add-investment-modal').foundation('reveal', 'close')
        #TODO 局部刷新即可
        $('.syndicate_info').fadeOut 'slow', ->
          $(this).html(data)
          $(this).fadeIn('slow')

  $('#close_investment').unbind('click').click (e)->
    e.preventDefault()
    if confirm_data = $(this).data('confirm')
      return unless window.confirm( confirm_data )
    $.post $(this).data('uri'), (data)->
      Alert.doit data, ->
        $('.syndicate_info').fadeOut 'slow', ->
          $(this).html(data)
          $(this).fadeIn('slow')
