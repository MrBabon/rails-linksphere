class ExhibitorsController < ApplicationController

    def show
        @exhibitor = Exhibitor.find(params[:id])
        authorize @exhibitor
    
        if current_user
          @event = @exhibitor.event
          user_participation = @event.participations.find_by(user: current_user)
    
          if @exhibitor.entreprise
            render json: {
              entreprise: EntrepriseSerializer.new(@exhibitor.entreprise).serializable_hash,
              user_participation: user_participation ? ParticipationSerializer.new(user_participation).serializable_hash : nil
            }
          else
            render json: { error: "Entreprise details not found for this exhibitor." }, status: :not_found
          end
        else
          render json: { error: "You must be logged in to access this page." }, status: :unauthorized
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Exhibitor not found." }, status: :not_found
      end
end
