class ChatroomsController < ApplicationController
  before_action :set_chatroom, only: [:show, :destroy]

  def show
    authorize @chatroom
    if @chatroom
      render json: ChatroomSerializer.new(@chatroom).serializable_hash, status: :ok
    else
      render json: { error: "The conversation has been deleted or does not exist." }, status: :not_found
    end
  end

  def index
    @chatrooms = policy_scope(Chatroom).where("user1_id = ? OR user2_id = ?", current_user.id, current_user.id)
    user_ids = @chatrooms.flat_map { |chatroom| [chatroom.user1_id, chatroom.user2_id] }.uniq - [current_user.id]

    if params[:search].present?
      @users = User.search_by_name(params[:search]).where(id: user_ids)
    else
      @users = User.where(id: user_ids)
    end

    render json: {
      chatrooms: ChatroomSerializer.new(@chatrooms).serializable_hash,
      users: UserSerializer.new(@users).serializable_hash
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
