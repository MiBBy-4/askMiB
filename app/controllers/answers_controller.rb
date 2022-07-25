# frozen_string_literal: true

class AnswersController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_question!
  before_action :set_answer!, except: :create
  def create
    @answer = @question.answers.build answer_params

    if @answer.save
      flash[:success] = t('.success')
      redirect_to question_path(@question)
    else
      flash[:danger] = t('flash.danger')
      @answers = @question.answers.order created_at: :desc
      render 'questions/show'
    end
  end

  def destroy
    if @answer.destroy
      flash[:success] = t('.success')
      redirect_to @question, status: :see_other
    else
      flash[:danger] = t('flash.danger')
      redirect_to @question
    end
  end

  def edit; end

  def update
    if @answer.update answer_params
      flash[:success] = t('.success')
      redirect_to question_path(@question, anchor: dom_id(@answer))
    else
      flash[:danger] = t('flash.danger')
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
