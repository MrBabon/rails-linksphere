class Repertoire < ApplicationRecord
  after_create :create_default_group
  belongs_to :user
  has_many :contact_groups, dependent: :destroy


  private

  def create_default_group
    self.contact_groups.create!(name: 'Everyone', deletable: false)
  end
  
end
