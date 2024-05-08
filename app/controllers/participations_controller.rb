class ParticipationsController < ApplicationController
    before_action :set_event, only: [:create, :destroy, :update]
    before_action :set_participation, only: [:destroy]


    def create
        @participation = @event.participations.new(participation_params)
        @participation.user = current_user
        
        authorize @participation
      
        if @participation.save
          render json: ParticipationSerializer.new(@participation).serializable_hash, status: :created
        else
          render json: { errors: @participation.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
      @participation = Participation.find_by(user_id: current_user.id, event_id: @event.id)
      visible = params[:participation][:visible_in_participants].present?
      @participation.visible_in_participants = !visible
  
      authorize @participation
      if @participation.update(participation_params)
        render json: {
            message: "Your participation visibility has been updated.",
            participation: ParticipationSerializer.new(@participation).serializable_hash
        }, status: :ok
    else
        render json: {
            errors: @participation.errors.full_messages
        }, status: :unprocessable_entity
    end
    end

    def destroy
      authorize @participation
      if @participation.destroy
          render json: { message: "Participation deleted successfully" }, status: :ok
      else
          render json: { errors: "Failed to delete participation" }, status: :unprocessable_entity
      end
    end
  
    private
  
    def set_event
      @event = Event.find(params[:event_id])
    end

    def set_participation
      @participation = @event.participations.find(params[:id])
    end
  
    def participation_params
      params.require(:participation).permit( :visible_in_participants)
    end
end
