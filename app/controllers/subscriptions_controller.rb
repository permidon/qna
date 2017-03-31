class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:create]

  # respond_to :js

  authorize_resource

  def create
    @subscription = @question.subscriptions.create(user: current_user)
    respond_with @question
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy
    respond_with(@subscription.question)
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end
end
