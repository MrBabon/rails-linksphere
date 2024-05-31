class UsersController < ApplicationController
  before_action :set_user, only: [:show]
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
    repertoire = current_user.repertoire
    authorize repertoire
    
    @groups = repertoire.contact_groups.includes(user_contact_groups: :user)
    @everyone_group = @groups.find_by(name: "Everyone")
    if params[:search].present?
      search = "%#{params[:search]}%"
      users = @everyone_group.users.where("first_name ILIKE ? OR last_name ILIKE ?", search, search)
      @search_active = true
    else
      users = []
      @search_active = false
    end

    render json: {
      repertoire: RepertoireSerializer.new(repertoire, include: [:contact_groups, :'contact_groups.user_contact_groups', :'contact_groups.user_contact_groups.user']).serializable_hash,
      users: UserSerializer.new(users, is_collection: true).serializable_hash[:data],
      search_active: @search_active
    }, status: :ok
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

  def show
    if @user == current_user
      render json: { message: "You are viewing your own profile", user: UserSerializer.new(@user).serializable_hash }
      return
    end

    if @user.entrepreneurs?
      Rails.logger.info "User is an entrepreneur"
      @entreprise = @user.entreprises_as_owner.first
    elsif @user.employee_relationships?
      Rails.logger.info "User is an employee"
      @employee = @user.entreprises_as_employee.first
    end

    @from_contact_group = session.delete(:from_contact_group)
    blocked = current_user.blocks_given.exists?(blocked_id: @user.id) || @user.blocks_given.exists?(blocked_id: current_user.id)
  if blocked
    render json: { error: "You cannot view this profile." }, status: :forbidden
    return
  end
  authorize @user

  response = {
    user: UserSerializer.new(@user).serializable_hash,
    from_contact_group: @from_contact_group
  }
  response[:entreprise] = EntrepriseSerializer.new(@entreprise).serializable_hash if @entreprise
  response[:employee] = EmployeeSerializer.new(@employee).serializable_hash if @employee

  render json: response
  rescue Pundit::NotAuthorizedError
  render json: { error: "You are not authorized to view this profile." }, status: :unauthorized
  rescue ActiveRecord::RecordNotFound
  render json: { error: "User not found." }, status: :not_found
  end

  private 

  def set_user
    @user = User.find(params[:id])
  end

end
