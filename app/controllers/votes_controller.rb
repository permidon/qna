class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_votable, only: [:create]
  before_action :set_vote_and_votable, only: [:destroy]
  before_action :check_vote_owner, only: :destroy
  before_action :check_votable_owner, only: :create

  after_action :publish_rating, only: [:create, :destroy]

  respond_to :json, only: :create
  respond_to :js, only: :destroy

  def create
    @vote = current_user.votes.create(value: params[:value], votable: @votable)
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

  def check_votable_owner
    unless !current_user.author_of?(@votable) && !@votable.votes.find_by(user_id: current_user.id)
      flash[:error] = 'You have no permission to do this action'
      redirect_to questions_path
    end
  end

  def check_vote_owner
    unless current_user.author_of?(@vote)
      flash[:error] = 'You have no permission to do this action'
      redirect_to questions_path
    end
  end

  def publish_rating
    return unless defined?(@vote)
    return if @vote.errors.any?
    ActionCable.server.broadcast(
      'votes',
      { vote: @vote, rating: @votable.rating }
    )
  end
end
