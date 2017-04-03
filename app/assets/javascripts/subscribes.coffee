# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.subscribe-link').bind 'ajax:success', (e, data, status, xhr) ->
    subscription = xhr.responseJSON
    $('.subscribe-link').hide()
    $('.error-messages').html('')
    $('.unsubscribe-link').attr("href", "/subscriptions/" + subscription.id).show()
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = xhr.responseJSON.errors
    $.each errors, (index, value) ->
      $('.error-messages').html("<p>" + index + ' ' + value + "</p>")

$(document).on('turbolinks:load', ready)