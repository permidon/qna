# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.vote-up-link, .vote-down-link').bind 'ajax:success', (e, data, status, xhr) ->

    div_vote = '.' + 'vote-' + data.vote.votable_type.toLowerCase() + '-' + data.vote.votable_id

    $(div_vote + " div.rating" + " p").html("<p> Rating: " + data.rating + "</p>")
    $(div_vote + " .vote-reset-link").attr("href", "/votes/" + data.vote.id).show()
    $(div_vote + " .vote-up-link").hide()
    $(div_vote + " .vote-down-link").hide()

    .bind 'ajax:error', (e, xhr, status, error) ->
      $(".alert").append(xhr.message)


  $('.vote-reset-link').bind 'ajax:success', (e, data, status, xhr) ->

    div_vote = '.' + 'vote-' + data.votable_type.toLowerCase() + '-' + data.votable_id

    $(div_vote + " div.rating" + " p").html("<p> Rating: " + data.rating + "</p>")
    $(div_vote + " .vote-reset-link").hide()
    $(div_vote + " .vote-up-link").show()
    $(div_vote + " .vote-down-link").show()

    .bind 'ajax:error', (e, xhr, status, error) ->
      errors = $.parseJSON(xhr.responseText)
      $.each errors, (index, value) ->
        $(".alert").append(value)

$(document).on('turbolinks:load', ready)