class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :destroy, :update]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'The question has been successfully created.'
    else
      flash[:error] = 'The question can not be created.'
      render :new
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      flash[:notice] ='The question has been successfully deleted.'
    else
      flash[:alert] ='You can not delete this question.'
    end
    redirect_to questions_path
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
      flash[:notice] ='The question has been successfully updated.'
    else
      flash[:alert] ='You can not update this question.'
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
