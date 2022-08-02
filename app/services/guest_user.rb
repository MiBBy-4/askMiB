# frozen_string_literal: true

class GuestUser
  def guest?
    true
  end

  def author?(_)
    false
  end

  def method_missing(name, *args, &block)
    return false if name.to_s.end_with?('role?')

    super(name, *args, &block)
  end

  def respond_ti_missing?(name, include_private)
    return true if name.to_s.end_with?('role?')

    super(name, include_private)
  end
end
