# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  showEditAnswerForm = (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('form.edit_answer[data-answer-id="' + answer_id + '"]').show();

  $(document).on 'click', '.edit-answer-link', showEditAnswerForm

  # -----Create new answer-----
  $('form.new_answer')
    # success create
  .bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText);
    answer = response.answer
    notice = response.notice
    $('.answer-errors').empty();
    $('.answers').append(JST["templates/answers/create"](answer));
    $('textarea#answer_body').val('');
    $('.notice').html(notice);
    # fail update
  .bind 'ajax:error', (e, xhr, status, error) ->
    # 422:
    #if (error == 'Unprocessable Entity')
      response = $.parseJSON(xhr.responseText);
      entity_error = response.notice_error
      notice = response.notice
      $('.answer-errors').html(entity_error);
      $('.notice').html(notice);

  # -----Update answer-----
  $('form.edit_answer').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText);
    answer = response.answer
    notice = response.notice

    $('form.edit_answer[data-answer-id="' + answer.id + '"]').hide()

    $('#answer_' + answer.id).html(JST["templates/answers/create"](answer))

    $('.notice').html(notice);

    # fail update
  .bind 'ajax:error', (e, xhr, status, error) ->
    # 422:
    #if (error == 'Unprocessable Entity')
    response = $.parseJSON(xhr.responseText);
    entity_error = response.notice_error
    notice = response.notice

    $('.notice').html(notice);

  # -----Update votes-----
  $('.answer_votes').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText);
    class_id = '#votes_'+response.class + '_' + response.id
    $(class_id).html(JST["templates/answers/votes"](response))