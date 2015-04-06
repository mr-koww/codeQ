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