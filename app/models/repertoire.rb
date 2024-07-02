class Repertoire < ApplicationRecord
  after_create :create_default_group
  belongs_to :user
  has_many :contact_groups, dependent: :destroy
  has_many:entreprise_contact_groups, dependent: :destroy
  has_many :entreprises, through: :entreprise_contact_groups


  private

  def create_default_group
    self.contact_groups.create!(name: 'Everyone', deletable: false)
  end

end
