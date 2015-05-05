# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  showEditQuestionForm = (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId');
    $('form#edit-question-' + question_id).show();

  showEditCommentForm = (e) ->
    e.preventDefault();
    $(this).hide();
    comment_id = $(this).data('commentId');
    $('form#edit-comment-' + comment_id).show();

  $(document).on 'click', '.edit-question-link', showEditQuestionForm;
  $(document).on 'click', '.edit-comment-link', showEditCommentForm;

  # -----VARIABLES-----
  questionId = $('.question').data('questionId')


  # -----Update votes-----
  $('.question_votes').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText);
    class_id = '#votes_' + response.class + '_' + response.id
    $(class_id).html(JST["templates/questions/votes"](response))


  # -----ADD NEW COMMENT (for auhtor)-----
  $('.new_comment').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText);
    comment = response.data
    comment_id = comment.id
    if !($("#comment_" + comment_id).length)
      $('.question_comments').append(JST["templates/comments/create"](comment))


  # -----PUBLISH NEW COMMENT (for subcribers)-----
  PrivatePub.subscribe '/questions/' + questionId + '/comments', (data, channel) ->
    comment = $.parseJSON(data['data'])
    comment_id = comment.id
    if !($("#comment_" + comment_id).length)
      $('.question_comments').append(JST["templates/comments/create"](comment))

