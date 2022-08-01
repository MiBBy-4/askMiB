class CommentsController < ApplicationController
  before_action :set_commentable!
  before_action :set_question

  def create
    @comment = @commentable.comments.build comment_params
    if @comment.save
      flash[:success] = 'Comment successfully created'
      redirect_to question_path(@question)
    else
      @comment = @comment.decorate
      @answer ||= @question.answers.build
      @answers = @question.answers.order created_at: :desc
      @answers = @answers.decorate
      @question = @question.decorate
      render('questions/show')
    end
  end

  def destroy
    comment = @commentable.comments.find params[:id]
    comment.destroy
    flash[:success] = 'Comment successfully deleted'
    redirect_to question_path(@question), status: :see_other
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end
  
  def set_commentable!
    klass = [Question, Answer].detect { |c| params["#{c.name.underscore}_id"]}
    raise ActiveRecord::RecordNotFound if klass.blank?

    @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end

  def set_question
    @question = @commentable.is_a?(Question) ? @commentable : @commentable.question
  end
end