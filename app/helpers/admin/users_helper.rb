module Admin
  module UsersHelper
    def user_roles
      User.roles.keys.map do |role|
        [ role, role ]
      end
    end
  end
end