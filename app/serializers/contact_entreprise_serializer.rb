class ContactEntrepriseSerializer
  include JSONAPI::Serializer
  attributes :category, :message, :user_id, :event_id, :entreprise_id, :created_at, :updated_at
end
