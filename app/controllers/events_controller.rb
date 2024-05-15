class EventsController < ApplicationController
    before_action :set_event, only: [:show, :exposant, :visitor]

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
        if @event
            authorize @event
            render json: EventSerializer.new(@event, { params: { current_user: current_user, include_participants: true } }).serializable_hash
        else
            render json: { error: "Event not found" }, status: :not_found
        end
    end

    def exposant
        authorize @event
        exhibitors = @event.exhibitors
        if exhibitors
            render json: EventSerializer.new(@event, include: [:exhibitors, 'exhibitors.entreprise', :participations]).serializable_hash
        else
            render json: { error: "Exhibitor not found" }, status: :not_found

        end
    end

    def visitor
        authorize @event, :visitor?
        visible_participations = @event.participations
                                            .where(visible_in_participants: true)
                                            .joins(:user)
                                            .order('users.first_name ASC')

        if current_user
            user_participation = @event.participations.find_by(user: current_user)
      
            # Vérifier si l'utilisateur a refusé d'être visible
            if user_participation && !user_participation.visible_in_participants
                Rails.logger.info "User #{current_user.id} is not visible in participants"
                render json: { error: "You do not have access to this page. Please validate your visibility to access it." }, status: :forbidden
                return
            end

            visible_participations = visible_participations.where.not(user_id: current_user.id)
          else
            Rails.logger.info "User is not authenticated"
            render json: { error: "You must be logged in to access this page." }, status: :unauthorized
            return
          end
      
          # Utilisation du serializer pour renvoyer les participations visibles en JSON
          render json: ParticipationSerializer.new(visible_participations, include: [:user]).serializable_hash
    end

    private

    def set_event
        @event = Event.find(params[:id])
    end
end
