class ChatroomsController < ApplicationController
  before_action :set_chatroom, only: [:show, :destroy]

  def show
    authorize @chatroom
    if @chatroom
      render json: ChatroomSerializer.new(@chatroom, include: [:user1, :user2]).serializable_hash, status: :ok
    else
      render json: { error: "The conversation has been deleted or does not exist." }, status: :not_found
    end
  end

  def index
    # Récupérer toutes les chatrooms où l'utilisateur est impliqué
    @chatrooms = Chatroom.where("user1_id = ? OR user2_id = ?", current_user.id, current_user.id)


    if params[:search].present?
      # Rechercher parmi les utilisateurs (other_user) liés à une chatroom avec current_user
      filtered_chatrooms = @chatrooms.select do |chatroom|
        other_user = chatroom.other_user(current_user)
        other_user.first_name.downcase.include?(params[:search].downcase) || other_user.last_name.downcase.include?(params[:search].downcase)
      end

      # Si des utilisateurs correspondent à la recherche, récupérer leurs infos
      @users = filtered_chatrooms.map { |chatroom| chatroom.other_user(current_user) }

      @search_active = true
    else
      filtered_chatrooms = @chatrooms
      @users = [] # Si pas de recherche, pas besoin de renvoyer d'utilisateurs
      @search_active = false
    end

    # Récupérer le dernier message pour chaque chatroom
    @last_messages = filtered_chatrooms.map do |chatroom|
      last_message = chatroom.messages.order(created_at: :desc).first
      { chatroom_id: chatroom.id, message: last_message }
    end

    # Renvoyer les chatrooms, les utilisateurs trouvés et l'état de la recherche
    render json: {
      chatrooms: ChatroomSerializer.new(filtered_chatrooms, { params: { current_user: current_user }, include: [:user1, :user2] }).serializable_hash,
      last_messages: @last_messages,
      users: UserSerializer.new(@users, is_collection: true).serializable_hash[:data], # Renvoyer les utilisateurs correspondant à la recherche
      search_active: @search_active
    }, status: :ok
  end

  def create
    other_user = User.find(params[:other_user_id])
    chatroom = find_or_create_chatroom(current_user, other_user)
    authorize chatroom
    render json: ChatroomSerializer.new(chatroom).serializable_hash, status: :created
  end

  def destroy
    @chatroom.destroy
    authorize @chatroom, :destroy?
    render json: { message: 'The chatroom has been successfully deleted.' }, status: :ok
  end

  private

  def set_chatroom
    @chatroom = Chatroom.find_by(id: params[:id])
    if @chatroom.nil?
      render json: { error: 'Chatroom not found' }, status: :not_found
    end
  end

  def find_or_create_chatroom(user1, user2)
    chatroom = Chatroom.find_by(user1: user1, user2: user2) || Chatroom.find_by(user1: user2, user2: user1)
    chatroom ||= Chatroom.create(user1: user1, user2: user2)
    chatroom
  end
end
