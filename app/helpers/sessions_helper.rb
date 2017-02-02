module SessionsHelper
  # Logs in the given user.
  def log_in(account)
    session[:account_id] = account.id
  end

  def current_user?(user)
    user == current_user
  end

  # Returns the current logged-in user (if any).
  def current_user
    @current_user ||= Account.find_by(id: session[:account_id])
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user.
  def log_out
    session.delete(:account_id)
    @current_user = nil
end
end
