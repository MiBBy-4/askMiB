module Admin
  class UserMailer < ApplicationMailer
    def bulk_import_done
      @user = params[:user]

      mail to: @user.email, subject: 'Setting users from ZIP file successfully done'
    end

    def bulk_import_faile
      @error = params[:error]
      @user = params[:user]

      mail to: @user.email, subject: 'Something went wrong'
    end
  end
end