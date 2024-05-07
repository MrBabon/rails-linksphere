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

  def my_events
    user = current_user
    authorize user

    events = user.events
    events = events.search_by_city(params[:city]) if params[:city].present?
    events = events.search_by_country(params[:country]) if params[:country].present?
    events = events.search_by_industry(params[:industry]) if params[:industry].present?
    events = events.search_by_region(params[:region]) if params[:region].present?
    events = events.search_by_title(params[:title]) if params[:title].present?
    events = events.sort_by { |e| [e.end_time < Time.zone.now ? 1 : 0, e.start_time] }

    events_by_month = events.group_by { |event| event.start_time.beginning_of_month }

    visible_in_participants = events.each_with_object({}) do |event, hash|
      participation = Participation.participation_for(user, event)
      hash[event.id] = participation&.visible_in_participants || false
    end

    serialized_events_by_month = events_by_month.transform_values do |events_in_month|
      events_in_month.map { |event| EventSerializer.new(event).serializable_hash }
    end



    render json: {
      events: serialized_events_by_month,
      visible_in_participants: visible_in_participants
    }, status: :ok
  end

end
