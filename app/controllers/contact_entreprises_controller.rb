class ContactEntreprisesController < ApplicationController
  before_action :set_entreprise, only: [:create]



  def create
    @contact_entreprise = ContactEntreprise.new(contact_entreprise_params)
    @contact_entreprise.entreprise = @entreprise
    @contact_entreprise.user = current_user

    if @contact_entreprise.save
      render json: ContactEntrepriseSerializer.new(@contact_entreprise).serializable_hash, status: :created
    else
      render json: { errors: @contact_entreprise.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private

  def set_entreprise
    @entreprise = Entreprise.find(params[:entreprise_id])
  end

  def contact_entreprise_params
    params.require(:contact_entreprise).permit(:category, :message, :event_id)
  end

end
