class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create
  before_action :set_answer, only: [:update, :destroy, :mark_best]
  before_action :set_question, only: [:update, :destroy, :mark_best]
  before_action :check_answer_owner, only: [:update, :destroy]
  before_action :check_question_owner, only: :mark_best

  after_action :publish_answer, only: :create

  respond_to :js

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

  def load_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = @answer.question
  end

  def check_question_owner
    unless current_user.author_of?(@question)
      flash[:error] = 'You have no permission to do this action'
      redirect_to questions_path
    end
  end

  def check_answer_owner
    unless current_user.author_of?(@answer)
      flash[:error] = 'You have no permission to do this action'
      redirect_to questions_path
    end
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
