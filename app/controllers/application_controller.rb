class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :set_default_locale
  
  #rescue_from ActionController::RoutingError, with: :not_found
  #rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to new_user_session_path, :alert => exception.message
  end

  protect_from_forgery with: :exception

  def raise_not_found
    raise ActionController::RoutingError.new("No route matches #{params[:unmatched_route]}")
  end


  private
    def configure_devise_permitted_parameters
      registration_params = [:name, :email, :password, :password_confirmation]

      if params[:action] == 'update'
        devise_parameter_sanitizer.for(:account_update) { 
          |u| u.permit(registration_params << :current_password)
        }
      elsif params[:action] == 'create'
        devise_parameter_sanitizer.for(:sign_up) { 
          |u| u.permit(registration_params) 
        }
      end
    end

    def init_neo4j_session
      Neo4j::Session.create_session(:server_db, "http://localhost:7474")
    end

    def set_default_locale
      I18n.locale = params[:locale] if params[:locale]
    end

    def default_url_options(options = {})
      {locale: I18n.locale}
    end

    def not_found
      respond_to do |format| 
        format.html{ render template: 'shared/not_found', layout: false, status: 404 }
      end
    end

end
