class EventsController < ApplicationController

    def index
        # Utilisez policy_scope pour s'assurer que seulement les événements autorisés sont chargés
        events = policy_scope(Event).where('end_time > ?', Time.zone.now - 1.day)
    
        # Filtrage des événements en fonction des paramètres
        events = events.search_by_city(params[:city]) if params[:city].present?
        events = events.search_by_country(params[:country]) if params[:country].present?
        events = events.search_by_industry(params[:industry]) if params[:industry].present?
        events = events.search_by_region(params[:region]) if params[:region].present?
        events = events.search_by_title(params[:title]) if params[:title].present?
    
        events_by_month = events.group_by { |event| event.start_time.beginning_of_month }
        sorted_events_by_month = events_by_month.sort_by { |month, _| month }.to_h
        participations = Participation.where(event: events, user: current_user).index_by(&:event_id)

        # Préparer les données pour la sérialisation
        serialized_data = sorted_events_by_month.transform_values do |monthly_events|
            EventSerializer.new(monthly_events, params: { current_user: current_user, participations: participations }).serializable_hash
        end

        render json: serialized_data
    end

    def show
        event = Event.find(params[:id])
        if event
            authorize event
            render json: EventSerializer.new(event).serializable_hash
        else
            render json: { error: "Event not found" }, status: :not_found
        end
    end

end
