class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: [:index, :create]

  authorize_resource

  def show
    @answer = Answer.find(params[:id])
    respond_with @answer, serializer: FullAnswerSerializer
  end

  def index
    @answers = @question.answers
    respond_with @answers
  end

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_resource_owner))
    respond_with @answer
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end