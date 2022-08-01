# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :set_question!, except: %i[index new create]
  before_action :fetch_tags, only: %i[new edit]
  def index
    @questions = Question.all_by_tags(params[:tag_ids]).page params[:page]
    @questions = @questions.decorate
    @tags = Tag.all
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.build question_params
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
    @answers = @question.answers.includes(:user).order created_at: :desc
    @answers = @answers.decorate
    @question = @question.decorate
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, tag_ids: [])
  end

  def set_question!
    @question = Question.find(params[:id])
  end

  def fetch_tags
    @tags = Tag.all
  end
end
