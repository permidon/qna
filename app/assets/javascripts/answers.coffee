# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('body').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault()
    $(@).hide()
    answer_id = $(@).data('answerId')
    $('form#edit-answer-' + answer_id).show()

  App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      question_id = $(".full-question").attr('id')
      @perform 'follow', question_id: question_id
    ,
    received: (data) ->
      return if gon.user_id is data.answer.user_id
      $('.answers').append JST['templates/answer'](
        answer: data.answer,
        attachments: data.attachments,
        question: data.question
      )
      $(document).ready(ready)
  })

$(document).on('turbolinks:load', ready)