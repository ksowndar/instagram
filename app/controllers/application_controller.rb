class ApplicationController < ActionController::Base

    rescue_from(ActionController::RoutingError) { render "errors/not_found" }
    before_action :configure_permitted_parameters, if: :devise_controller?
   
    protected 

    def configure_permitted_parameters 
        devise_parameter_sanitizer.permit(:account_update, keys: [:username, :first_name, :last_name, :email, :password, :profile_image, :description, :website])
        devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :first_name, :last_name, :email, :password])
    end
end
