class EmployeeSerializer
  include JSONAPI::Serializer
  attributes :user_id, :entreprise_id, :role
end
