class IndexUserSerializer < ActiveModel::Serializer
  attributes :id, :name, :image_url, :is_following

  def is_following
    relationships = @instance_options[:relationships]
    if relationships.length > 0
      relationship = relationships.find do |relationship|
        relationship[:follow_id] == object[:id]
      end
      return !!relationship
    else
      return false
    end
  end
end
