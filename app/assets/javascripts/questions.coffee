# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  showEditQuestionForm = (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId');
    $('form#edit-question-form[data-question-id="' + question_id + '"]').show();

  $(document).on 'click', '.edit-question-link', showEditQuestionForm;

  # -----Update votes-----
  $('.votes').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText);
    class_id = '#'+response.class + response.id
    $(class_id).html(JST["templates/questions/votes"](response))

