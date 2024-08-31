class ApplicationController < ActionController::Base

  include Pundit
  def current_user
    nil
  end
end
