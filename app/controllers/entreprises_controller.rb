class EntreprisesController < ApplicationController
    before_action :set_entreprise, only: [:show, :add_to_repertoire]

    def show
        authorize @entreprise
        # @contact_entreprise = ContactEntreprise.new(entreprise: @entreprise)
        @employees = @entreprise.employees
        @entrepreneurs = @entreprise.entrepreneurs

        render json: EntrepriseSerializer.new(@entreprise, include: [:employees, :entrepreneurs]).serializable_hash
    end

    def add_to_repertoire
        @repertoire = current_user.repertoire

        entreprise_contact_group = @repertoire.entreprise_contact_groups.create(entreprise: @entreprise)

        if entreprise_contact_group.persisted?
            render json: EntrepriseContactGroupSerializer.new(entreprise_contact_group).serializable_hash
        else
            render json: { error: entreprise_contact_group.errors.full_messages }, status: :unprocessable_entity
        end
    end


    private

    def set_entreprise
        @entreprise = Entreprise.find(params[:id])
    end
end
