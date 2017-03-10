class VotesChannel < ApplicationCable::Channel
  def follow
    stream_from "votes"
  end
end