class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :update, :destroy]
  before_action :check_owner, only: [:update, :destroy]
  before_action :build_answer, only: :show
  before_action :set_gon_variable, only: :show

  after_action :publish_question, only: :create

  respond_to :js, only: :update

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def destroy
    respond_with(@question.destroy)
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def build_answer
    @answer = @question.answers.build
  end

  def check_owner
    unless current_user.author_of?(@question)
      flash[:error] = 'You have no permission to do this action'
      redirect_to questions_path
    end
  end

  def set_gon_variable
    gon.user_id = current_user.id if user_signed_in?
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/short_question',
        locals: { question: @question }
      )
    )
  end
end
