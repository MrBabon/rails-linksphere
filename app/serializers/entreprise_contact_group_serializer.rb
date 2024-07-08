class EntrepriseContactGroupSerializer
  include JSONAPI::Serializer
  attributes :id, :repertoire_id, :entreprise_id
end
