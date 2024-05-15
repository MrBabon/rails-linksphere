class EntreprisesController < ApplicationController
    before_action :set_entreprise, only: [:show]

    def show
        authorize @entreprise
        # @contact_entreprise = ContactEntreprise.new(entreprise: @entreprise)
        @employees = @entreprise.employees
        @entrepreneurs = @entreprise.entrepreneurs
    
        render json: EntrepriseSerializer.new(@entreprise, include: [:employees, :entrepreneurs]).serializable_hash
    end

    private

    def set_entreprise
        @entreprise = Entreprise.find(params[:id])
    end
end
