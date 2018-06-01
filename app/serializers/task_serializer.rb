class TaskSerializer < ActiveModel::Serializer
  attributes :id, :description, :datetime, :finished, :important
end
