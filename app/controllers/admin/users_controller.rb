# frozen_string_literal: true

module Admin
  class UsersController < BaseController
    before_action :require_authentication
    before_action :set_user!, only: %i[edit update destroy]
    before_action :authorize_user!
    after_action :verify_authorized

    def index
      respond_to do |format|
        format.html { @users = User.order(created_at: :desc).page params[:page] }
        format.zip { respond_with_zipped_users }
      end
    end

    def create
      if params[:archive].present?
        UserBulkImportJob.perform_later create_blob, current_user
        flash[:success] = 'Users imported!'
      end

      redirect_to admin_users_path
    end

    def edit; end

    def update
      if @user.update user_params
        flash[:success] = 'User was successfully updated'
        redirect_to admin_users_path
      else
        flash[:error] = 'Something went wrong'
        render :edit
      end
    end

    def destroy
      if @user.destroy
        flash[:success] = 'User was successfully deleted.'
        redirect_to admin_users_path, status: :see_other
      else
        flash[:error] = 'Something went wrong'
        redirect_to admin_users_path
      end
    end

    private

    def create_blob
      file = File.open params[:archive]
      result = ActiveStorage::Blob.create_and_upload! io: file, filename: params[:archive].original_filename
      file.close
      result.key
    end

    def respond_with_zipped_users
      compressed_filestream = Zip::OutputStream.write_buffer do |zos|
        User.order(created_at: :desc).each do |user|
          zos.put_next_entry "user_#{user.id}.xlsx"
          zos.print render_to_string(
            layout: false, handlers: [:axlsx], formats: [:xlsx],
            template: 'admin/users/user',
            locals: { user: user }
          )
        end
      end

      compressed_filestream.rewind
      send_data compressed_filestream.read, filename: 'users.zip'
    end

    def set_user!
      @user = User.find params[:id]
    end

    def user_params
      params.require(:user).permit(:email, :name, :password, :password_confirmation, :role).merge(admin_edit: true)
    end

    def authorize_user!
      authorize(@user || User)
    end
  end
end
