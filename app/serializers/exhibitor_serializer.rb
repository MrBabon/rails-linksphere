class ExhibitorSerializer
  include JSONAPI::Serializer
  attributes :id, :event_id

  belongs_to :entreprise, serializer: EntrepriseSerializer
end
