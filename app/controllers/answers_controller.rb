class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @question, notice: 'The answer has been successfully created.'
    else
      render "questions/show"
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy if current_user.author_of?(@answer)
    redirect_to @answer.question, notice: 'The answer has been successfully deleted.'
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
