class QuestionsController < ApplicationController
  before_action :set_question, except: [:index, :new, :create]
  def index
    @questions = Question.all 
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      flash[:success] = "Question successfully created"
      redirect_to questions_path
    else
      flash[:danger] = "Something went wrong"
      render 'new'
    end
  end

  def edit; end
  
  def update
    if @question.update(question_params)
      flash[:success] = "Question was successfully updated"
      redirect_to questions_path
    else
      flash[:danger] = "Something went wrong"
      render 'edit'
    end
  end
  
  def destroy
    if @question.destroy
      flash[:success] = 'Question was successfully deleted.'
      redirect_to questions_path
    else
      flash[:danger] = 'Something went wrong'
      redirect_to questions_path
    end
  end

  def show; end
  
  

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def set_question
    @question = Question.find(params[:id])
  end
end