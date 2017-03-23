class Api::V1::QuestionsController < Api::V1::BaseController
  def show
    @question = Question.find(params[:id])
    respond_with @question, serializer: FullQuestionSerializer
  end

  def index
    @questions = Question.all
    respond_with @questions
  end
end