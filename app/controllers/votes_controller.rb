class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_votable, only: [:create]

  after_action :publish_rating, only: [:create, :destroy]

  def create
    if !current_user.author_of?(@votable) && !@votable.votes.find_by(user_id: current_user.id)
      @vote = current_user.votes.new(value: params[:value], votable: @votable)
      if @vote.save
        render json: { vote: @vote, rating: @votable.rating }
      else
        render json: @vote.errors.full_messages, status: :unprocessable_entity
      end
    else
      render json: { message: 'You have no permission to perform this action' }, status: :forbidden
    end
  end

  def destroy
    @vote = Vote.find(params[:id])
    @votable = @vote.votable
    
    if current_user.author_of?(@vote)
      if @vote.destroy
        render json: { vote: @vote, rating: @votable.rating }
      else
        render json: @vote.errors.full_messages, status: :unprocessable_entity
      end
    else
      render json: { message: 'You have no permission to perform this action' }, status: :forbidden
    end
  end

  private

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
      { vote: @vote, rating: @votable.rating }
    )
  end
end
