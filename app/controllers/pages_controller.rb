class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :redirect]
  
  def home
    render json: { message: "Bienvenue dans l'api linksphere !" }
  end

  def redirect
    user_id = params[:user_id]
    if user_id.present?
      # Redirigez vers la page utilisateur dans l'application mobile
      render plain: "app://user/#{user_id}"
    else
      # Sinon, redirigez vers la page d'accueil de l'application
      # A changer plus tard
      redirect_to "https://www.christophe-danna.com"
    end
  end


end
