class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource

  def show
    @answer = Answer.find(params[:id])
    respond_with @answer, serializer: FullAnswerSerializer
  end

  def index
    @question = Question.find(params[:question_id])
    @answers = @question.answers
    respond_with @answers
  end
end