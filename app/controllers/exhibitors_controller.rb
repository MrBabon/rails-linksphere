class ExhibitorsController < ApplicationController

    def show
        @exhibitor = Exhibitor.find(params[:id])
        authorize @exhibitor

        if @exhibitor.entreprise
            render json: EntrepriseSerializer.new(@exhibitor.entreprise).serializable_hash
        else
            render json: { error: "Entreprise details not found for this exhibitor." }, status: :not_found
        end
    rescue ActiveRecord::RecordNotFound
        render json: { error: "Exhibitor not found." }, status: :not_found
    end
end
