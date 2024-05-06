class ParticipationsController < ApplicationController
    before_action :set_event

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
  
    private
  
    def set_event
      @event = Event.find(params[:event_id])
    end
  
    def participation_params
      params.require(:participation).permit( :visible_in_participants)
    end
end
