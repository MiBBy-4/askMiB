class AnswersController < ApplicationController
  before_action :set_question!
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
    answer = @question.answers.find params[:id]
    if answer.destroy
      flash[:success] = 'Answer was successfully deleted.'
      redirect_to @question, status: 303
    else
      flash[:danger] = 'Something went wrong'
      redirect_to @question
    end
  end
  
  
  private

  def set_question!
    @question = Question.find params[:question_id]
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end