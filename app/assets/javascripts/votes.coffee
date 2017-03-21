# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.vote-up-link, .vote-down-link').bind 'ajax:success', (e, data, status, xhr) ->
    vote = xhr.responseJSON
    vote_div = '.' + 'vote-' + vote.votable_type.toLowerCase() + '-' + vote.votable_id
    $(vote_div + " .vote-reset-link").attr("href", "/votes/" + vote.id).show()
    $(vote_div + " .vote-up-link").hide()
    $(vote_div + " .vote-down-link").hide()
    $(".vote-alert").html("")
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = xhr.responseJSON.errors
    $.each errors, (index, value) ->
      $(".vote-alert").html("<p>" + value + "</p>")
    $('.error-messages').html(xhr.responseJSON) if error = 'Forbidden'

  $('.vote-reset-link').bind 'ajax:success', (e, data, status, xhr) ->
    vote = xhr.responseJSON
    vote_div = '.' + 'vote-' + vote.votable_type.toLowerCase() + '-' + vote.votable_id
    $(vote_div + " .vote-reset-link").hide()
    $(vote_div + " .vote-up-link").show()
    $(vote_div + " .vote-down-link").show()
    $(".vote-alert").html("")
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = xhr.responseJSON.errors
    $.each errors, (index, value) ->
      $(".vote-alert").html("<p>" + value + "</p>")
    $('.error-messages').html(xhr.responseJSON) if error = 'Forbidden'



  App.cable.subscriptions.create('VotesChannel', {
    connected: ->
      @perform 'follow'
    ,
    received: (data) ->
      vote = data.vote
      rating = data.rating
      vote_div = '.' + 'vote-' + vote.votable_type.toLowerCase() + '-' + vote.votable_id
      $(vote_div + " .rating" + " .rating-value").html("<p> Rating: " + rating + "</p>")
      $(document).ready(ready)
  })

$(document).on('turbolinks:load', ready)