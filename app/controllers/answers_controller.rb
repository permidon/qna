class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:destroy, :update]

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
    redirect_to @answer.question
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
      flash[:notice] ='The answer has been successfully updated.'
    else
      flash[:alert] ='You can not update this answer.'
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
