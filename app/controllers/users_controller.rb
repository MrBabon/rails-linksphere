class UsersController < ApplicationController
  before_action :authenticate_user!

  def profil
    user = current_user
    authorize user
    avatar_url = user.avatar_url # Utilise la méthode pour obtenir l'URL de l'avatar
  
    render json: {
      user: UserSerializer.new(user).serializable_hash[:data][:attributes],
      avatar_url: avatar_url
    }, status: :ok
  end

  def repertoire
    repertoires = current_user.repertoire
    authorize repertoires
    render json: repertoires, include: { contact_groups: {} }, each_serializer: RepertoireSerializer
  end

end
