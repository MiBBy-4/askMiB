# frozen_string_literal: true

class UserDecorator < ApplicationDecorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
  def name_or_email
    return name if name.present?

    email.split('@')[0]
  end

  def gravatar(size: 30, css_class: '')
    h.image_tag "https://www.gravatar.com/avatar/#{gravatar_hash}.jpg?s=#{size}",
                class: "rounded #{css_class}", alt: name_or_email
  end
end
