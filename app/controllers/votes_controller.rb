class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_votable, only: [:create]
  before_action :set_vote_and_votable, only: [:destroy]

  after_action :publish_rating, only: [:create, :destroy]

  respond_to :json, only: :create
  respond_to :js, only: :destroy

  load_resource :question
  load_resource :answer
  load_and_authorize_resource :vote, :through => [:question, :answer]

  def create
    @vote = @votable.votes.create(value: params[:value], user: current_user)
    respond_with(@vote, location: @votable, status: 200)
  end

  def destroy
    respond_with(@vote.destroy, location: @votable)
  end

  private

  def set_vote_and_votable
    @vote = Vote.find(params[:id])
    @votable = @vote.votable
  end

  def set_votable
    votable_id = params.keys.detect{ |k| k.to_s =~ /.*_id/ }
    model_klass = votable_id.chomp('_id').classify.constantize
    @votable = model_klass.find(params[votable_id])
  end

  def publish_rating
    return unless defined?(@vote)
    return if @vote.errors.any?
    ActionCable.server.broadcast(
      'votes',
      { vote: @vote, rating: @vote.votable.rating }
    )
  end
end
