class ApplicationController < ActionController::API
  include Pundit::Authorization
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Gestion des erreurs pour des cas spécifiques
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found


  protected
    
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone, :job, :industry, :biography, :website, :linkedin, :instagram, :facebook, :twitter, :email, :password, :confirm_password, :current_password, :avatar])
  end
  
  def user_not_authorized
    render json: { error: "You are not authorized to perform this action." }, status: :forbidden
  end

  def record_not_found
      render json: { error: "Resource not found." }, status: :not_found
  end
end
