# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  showEditAnswerForm = (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('form#edit-answer-form[data-answer-id="' + answer_id + '"]').show();

  $(document).on 'click', '.edit-answer-link', showEditAnswerForm