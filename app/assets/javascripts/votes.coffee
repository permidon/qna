# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.vote-up-link, .vote-down-link').bind 'ajax:success', (e, data, status, xhr) ->
    vote = xhr.responseJSON.vote
    rating = xhr.responseJSON.rating
    vote_div = '.' + 'vote-' + vote.votable_type.toLowerCase() + '-' + vote.votable_id
#    $(vote_div + " .rating" + " .rating-value").html("<p> Rating: " + rating + "</p>")
    $(vote_div + " .vote-reset-link").attr("href", "/votes/" + vote.id).show()
    $(vote_div + " .vote-up-link").hide()
    $(vote_div + " .vote-down-link").hide()
    $(".vote-alert").html("")
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = xhr.responseJSON
    $.each errors, (index, value) ->
      $(".vote-alert").html("<p>" + value + "</p>")

  $('.vote-reset-link').bind 'ajax:success', (e, data, status, xhr) ->
    vote = xhr.responseJSON.vote
    rating = xhr.responseJSON.rating
    vote_div = '.' + 'vote-' + vote.votable_type.toLowerCase() + '-' + vote.votable_id
#    $(vote_div + " .rating" + " .rating-value").html("<p> Rating: " + rating + "</p>")
    $(vote_div + " .vote-reset-link").hide()
    $(vote_div + " .vote-up-link").show()
    $(vote_div + " .vote-down-link").show()
    $(".vote-alert").html("")
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = xhr.responseJSON
    $.each errors, (index, value) ->
      $(".vote-alert").html("<p>" + value + "</p>")

  App.cable.subscriptions.create('VotesChannel', {
    connected: ->
      @perform 'follow'
    ,
    received: (data) ->
      vote = data.vote
      rating = data.rating
      vote_div = '.' + 'vote-' + vote.votable_type.toLowerCase() + '-' + vote.votable_id
      $(vote_div + " .rating" + " .rating-value").html("<p> Rating: " + rating + "</p>")
  })

$(document).on('turbolinks:load', ready)