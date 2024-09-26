class BlocksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_block, only: [:destroy]

  # Crée un blocage d'utilisateur
  def create
    blocked_user = User.find(params[:blocked_id])
    block = current_user.blocks_given.create!(blocked: blocked_user)

    authorize block

    # Supprimer la conversation si nécessaire
    chat = Chatroom.find_by(id: params[:chatroom_id])
    if chat
      authorize chat, :destroy?
      chat.destroy
      ChatroomChannel.broadcast_to(chat, { action: "chatroom_deleted" })
    end

    # Supprimer du répertoire des deux utilisateurs
    remove_from_repertoires(current_user, blocked_user)

    render json: { message: "User has been blocked and the conversation was deleted." }, status: :ok
  end

  # Supprime un blocage
  def destroy
    authorize @block

    if current_user == @block.blocker
      @block.destroy
      render json: { message: 'User has been successfully unblocked.' }, status: :ok
    else
      render json: { error: 'You do not have permission to unblock this user.' }, status: :forbidden
    end
  end

  private

  def set_block
    @block = Block.find(params[:id])
  end

  # Supprime les utilisateurs bloqués de leurs répertoires respectifs
  def remove_from_repertoires(user, blocked_user)
    # Repertoire de l'utilisateur bloqué
    repertoire_other = blocked_user.repertoire
    if repertoire_other
      everyone_group_other = repertoire_other.contact_groups.find_by(name: 'Everyone')
      if everyone_group_other
        association = UserContactGroup.find_by(user: user, contact_group: everyone_group_other)
        association.destroy if association
      end
    end

    # Repertoire de l'utilisateur courant
    repertoire = user.repertoire
    if repertoire
      everyone_group = repertoire.contact_groups.find_by(name: 'Everyone')
      if everyone_group
        association = UserContactGroup.find_by(user: blocked_user, contact_group: everyone_group)
        association.destroy if association
      end
    end
  end
end
