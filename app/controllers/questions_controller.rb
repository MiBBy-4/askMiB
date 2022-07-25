# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :set_question!, except: %i[index new create]
  def index
    @questions = Question.order(created_at: :desc).page params[:page]
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      flash[:success] = t('.success')
      redirect_to questions_path
    else
      flash[:danger] = t('flash.danger')
      render 'new'
    end
  end

  def edit; end

  def update
    if @question.update(question_params)
      flash[:success] = t('.success')
      redirect_to questions_path
    else
      flash[:danger] = t('flash.danger')
      render 'edit'
    end
  end

  def destroy
    if @question.destroy
      flash[:success] = t('.success')
    else
      flash[:danger] = t('flash.danger')
    end
    redirect_to questions_path
  end

  def show
    @answer = @question.answers.build
    @answers = @question.answers.order created_at: :desc
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def set_question!
    @question = Question.find(params[:id])
  end
end
