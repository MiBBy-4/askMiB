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

    def bulk_export_done
      @user = params[:user]
      zipped_blob = params[:zipped_blob]

      attachments[zipped_blob.attachable_filename] = zipped_blob.download
      mail to: @user.email, subject: 'Export users finally completed'
    end
  end
end