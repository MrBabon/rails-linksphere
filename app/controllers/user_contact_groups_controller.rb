class UserContactGroupsController < ApplicationController
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
          user_contact_group: UserContactGroupSerializer.new(@user_contact_group).serializable_hash,
          entreprise: @entreprise ? EntrepriseSerializer.new(@entreprise).serializable_hash : nil,
          employee: @employee ? EmployeeSerializer.new(@employee).serializable_hash : nil
        }
    end
end
