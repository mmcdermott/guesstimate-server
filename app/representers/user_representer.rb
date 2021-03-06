require 'roar/decorator'

class UserRepresenter < Roar::Decorator
  include Roar::JSON
  include Roar::JSON::HAL

  property :id
  property :name
  property :picture
  property :created_at
  property :updated_at
  property :public_model_count
  property :private_model_count
  property :has_private_access

  nested :plan do
    property :private_model_limit
  end
end
