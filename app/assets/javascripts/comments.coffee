# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('body').on 'click', '.new-comment-link', (e) ->
    e.preventDefault()
    commentable_id = $(@).data('commentableId')
    commentable_type = $(@).data('commentableType')
    $('form#new-' + commentable_type + '-' + commentable_id + '-comment').show()


  $('.new-comment').bind 'ajax:success', (e, data, status, xhr) ->
    comment = xhr.responseJSON.comment
    comment_div = '.' + 'comments-' + comment.commentable_type.toLowerCase() + '-' + comment.commentable_id
    comment_form = 'form#new-' + comment.commentable_type.toLowerCase() + '-' + comment.commentable_id + '-comment'
    $(comment_div).append("<p class='small'>" + comment.body + "</p>");
    $('.new-comment-form').val('');
    $(comment_form).hide()
    $(".comment-errors").html('')
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = xhr.responseJSON
    $.each errors, (index, value) ->
      $(".comment-errors").html("<p>" + value + "</p>")

$(document).on('turbolinks:load', ready)