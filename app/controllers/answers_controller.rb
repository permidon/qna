class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:new, :create]
  before_action :set_answer, only: [:show, :destroy]

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      flash[:notice] = 'The answer has been successfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  def show
  end

  def destroy
    @answer.destroy if current_user == @answer.user
    flash[:notice] = 'The answer has been successfully deleted.'
    redirect_to @answer.question
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
