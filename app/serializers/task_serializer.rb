class TaskSerializer < ActiveModel::Serializer
  attributes :id, :description, :datetime, :finished, :important

  def datetime
    object.datetime.strftime('%-d/%-m/%y %H:%M')
  end
end
