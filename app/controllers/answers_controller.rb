class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: :create
  before_action :set_answer_and_question, only: [:update, :destroy, :mark_best]

  after_action :publish_answer, only: :create

  respond_to :js

  authorize_resource

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def mark_best
    respond_with(@answer.set_best_status)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer_and_question
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end

  def publish_answer
    return if @answer.errors.any?

    attachments = []
    @answer.attachments.each do |a|
      attachment = {}
      attachment[:id] = a.id
      attachment[:url] = a.file.url
      attachment[:name] = a.file.identifier
      attachments << attachment
    end

    ActionCable.server.broadcast(
      "answers-question-#{@question.id}",
      answer: @answer,
      attachments: attachments,
      question: @question
    )
  end
end
