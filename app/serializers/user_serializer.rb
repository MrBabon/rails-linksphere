class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :first_name, :last_name, :phone, :job, :biography, :industry, :website, :linkedin, :instagram, :facebook, :twitter, :avatar_url, :qr_code, :created_at, :push_notifications, :messages_from_contacts, :messages_from_everyone

  attribute :created_date do |user|
    user.created_at && user.created_at.strftime('%d/%m/%Y')
  end

end
