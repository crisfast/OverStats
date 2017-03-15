class ApplicationController < ActionController::Base
    before_filter :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
   devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation) }
  end
  protect_from_forgery with: :exception
end
