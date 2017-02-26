# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('body').on 'click', '.edit-question-link', (e) ->
    e.preventDefault()
    $(@).hide()
    question_id = $(@).data('questionId')
    $('form#edit-question-' + question_id).show()

$(document).on('turbolinks:load', ready)