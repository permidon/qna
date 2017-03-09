class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:destroy, :update, :mark_best]
  before_action :set_question, only: [:destroy, :update, :mark_best]
  after_action :publish_answer, only: [:create]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user

    if @answer.save
      flash[:notice] = 'The answer has been successfully created.'
    else
      flash[:error] = 'The answer can not be created.'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] ='The answer has been successfully deleted.'
    else
      flash[:alert] ='You can not delete this answer.'
    end
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      flash[:notice] ='The answer has been successfully updated.'
    else
      flash[:alert] ='You can not update this answer.'
    end
  end

  def mark_best
    if current_user.author_of?(@question)
      @answer.set_best_status
      flash[:notice] ='The answer has been marked as the best.'
    else
      flash[:alert] ='You can not mark this answer.'
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = @answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def publish_answer
    return if @answer.errors.any?

    attachments = []
    @answer.attachments.each do |a|
      attachment = {}
      attachment[:id] = a.id
      attachment[:file_url] = a.file.url
      attachment[:file_name] = a.file.identifier
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
