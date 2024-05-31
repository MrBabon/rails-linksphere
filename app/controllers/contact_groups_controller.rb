class ContactGroupsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_contact_group, only: [:show, :destroy, :update]

    def show
        if @contact_group.nil?
            render json: { error: "Contact Group not found or access denied." }, status: :not_found
            return
        end
        
        @users = @contact_group.users.joins(:user_contact_groups).select('users.*, user_contact_groups.created_at AS created_at').order('created_at DESC, last_name')
        if params[:search].present?
          search_term = "%#{params[:search]}%"
          @users = @contact_group.users.where("first_name ILIKE ? OR last_name ILIKE ?", search_term, search_term).order(:last_name)
          @search_active = true
        else
          @users = @contact_group.users.order(:last_name)
          @search_active = false
        end
    
        render json: {
            contact_group: ContactGroupSerializer.new(@contact_group, include: [:user_contact_groups, :'user_contact_groups.user']).serializable_hash,
            users: UserSerializer.new(@users, is_collection: true).serializable_hash[:data],
            search_active: @search_active
          }, status: :ok

      rescue ActiveRecord::RecordNotFound
        render json: { error: "Access denied or Contact Group not found." }, status: :not_found
    end

    def create
      @repertoire = current_user.repertoire
      @contact_group = @repertoire.contact_groups.build(contact_group_params.merge(deletable: true))

      if @contact_group.save
        render json: @contact_group, status: :created, serializer: ContactGroupSerializer
      else
        render json: { errors: @contact_group.errors.full_messages }, status: :unprocessable_entity
      end
      authorize @contact_group, :create?

    end
    
    private

    def set_contact_group
        repertoire = current_user.repertoire
        if repertoire.present?
        @contact_group = repertoire.contact_groups.find_by(id: params[:id])
        authorize @contact_group, :show? if @contact_group
        else
        @contact_group = nil
        end    
    end

    def contact_group_params
      params.require(:contact_group).permit(:name)
    end
end
