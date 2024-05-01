class Entrepreneur < ApplicationRecord
  belongs_to :user
  belongs_to :entreprise

  # def create
  #   if current_user.employees.exists?
  #     redirect_to profil_user_path, alert: 'Vous êtes déjà enregistré en tant qu’employé.'
  #   else
  #     # Logique pour créer un entrepreneur
  #   end
  # end

end
