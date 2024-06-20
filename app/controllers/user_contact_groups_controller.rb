class UserContactGroupsController < ApplicationController
    after_action :verify_authorized, except: [:create]

    def show
        @user = User.find(params[:id])
        authorize @user
        @repertoire = current_user.repertoire
        @contact_groups = @repertoire.contact_groups
        @user_contact_group = current_user.repertoire.contact_groups
                                    .map(&:user_contact_groups)
                                    .flatten
                                    .find { |ucg| ucg.user_id == @user.id }
        user_in_repertoire = current_user.repertoire.contact_groups.any? do |group|
          group.users.exists?(@user.id)
        end
        if @user.entrepreneurs?
          @entreprise = @user.entreprises_as_owner.first
        elsif @user.employee_relationships?
          @employee = @user.entreprises_as_employee.first
        end
        unless user_in_repertoire
          render json: { error: "Access denied because this user is not in your directory." }, status: :forbidden
          return
        end

        render json: {
          user: UserSerializer.new(@user).serializable_hash,
          contact_group: ContactGroupSerializer.new(@contact_groups).serializable_hash,
          user_contact_group: UserContactGroupSerializer.new(@user_contact_group).serializable_hash,
          entreprise: @entreprise ? EntrepriseSerializer.new(@entreprise).serializable_hash : nil,
          employee: @employee ? EmployeeSerializer.new(@employee).serializable_hash : nil
        }
    end

    def create
      Rails.logger.debug("Current user: #{current_user.inspect}")
      user_to_add = User.find(params[:user_contact_group][:user_id])
      repertoire = current_user&.repertoire
      if repertoire.nil?
        render json: { error: "Repertoire not found" }, status: :not_found
        return
      end
      contact_group = repertoire.contact_groups.find_by(name: 'Everyone')

      if contact_group.nil?
        render json: { error: "Contact group 'Everyone' not found" }, status: :not_found
      end

      ActiveRecord::Base.transaction do
        user_contact_group = UserContactGroup.find_or_initialize_by(
          user_id: user_to_add.id,
          current_user_id: current_user.id
        )
        authorize user_contact_group

        if user_contact_group.new_record?
          user_contact_group.save!
        end

        user_group = UserGroup.find_or_initialize_by(
          contact_group_id: contact_group.id,
          user_contact_group_id: user_contact_group.id
        )
        authorize user_group

        if user_group.new_record?
          user_group.save!
        end

        render json: UserContactGroupSerializer.new(user_contact_group).serializable_hash, status: :created
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

    end

    def update
      @user_contact_group = UserContactGroup.find(params[:id])
      authorize @user_contact_group

      if @user_contact_group.update(user_contact_group_params)
        render json: UserContactGroupSerializer.new(@user_contact_group).serializable_hash, status: :ok
      else
        render json: @user_contact_group.errors, status: :unprocessable_entity
      end
    end

    def add_to_group
      user_id = params[:user_contact_group][:user_id]
      group_id = params[:user_contact_group][:contact_group_id]

      @user_contact_group = UserContactGroup.find_or_initialize_by(user_id: user_id)
      authorize @user_contact_group

      if UserGroup.exists?(user_contact_group: @user_contact_group, contact_group_id: group_id)
        render json: { message: "User already in group" }, status: :ok
        return
      end

      if @user_contact_group.save
        user_group_association = UserGroup.find_or_create_by(user_contact_group: @user_contact_group, contact_group_id: group_id)

        render json: UserContactGroupSerializer.new(@user_contact_group).serializable_hash, status: :created
      else
        render json: @user_contact_group.errors, status: :unprocessable_entity
      end
    end

    private

    def user_contact_group_params
        params.require(:user_contact_group).permit(:user_id)
    end

    def add_user_to_group(user_id, contact_id, group_id)
      user_contact_group = UserContactGroup.find_or_initialize_by(user_id: user_id)
      unless UserGroup.exists?(user_contact_group: user_contact_group, contact_group_id: group_id)
        UserGroup.create(user_contact_group: user_contact_group, contact_group_id: group_id)
      end
    end

end
