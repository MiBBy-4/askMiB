class AnswersController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_question!
  before_action :set_answer!, except: :create
  def create
    @answer = @question.answers.build answer_params

    if @answer.save
      flash[:success] = "Answer successfully created"
      redirect_to question_path(@question)
    else
      flash[:danger] = "Something went wrong"
      @answers = @question.answers.order created_at: :desc
      render 'questions/show'
    end
  end

  def destroy
    if @answer.destroy
      flash[:success] = 'Answer was successfully deleted.'
      redirect_to @question, status: 303
    else
      flash[:danger] = 'Something went wrong'
      redirect_to @question
    end
  end

  def edit; end

  def update
    if @answer.update answer_params
      flash[:success] = "Answer was successfully updated"
      redirect_to question_path(@question, anchor: dom_id(@answer))
    else
      flash[:danger] = "Something went wrong"
      render 'edit'
    end
  end

  private

  def set_question!
    @question = Question.find params[:question_id]
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_answer!
    @answer = @question.answers.find params[:id]
  end
end
