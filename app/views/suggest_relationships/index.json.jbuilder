json.array!(@suggest_relationships) do |suggest_relationship|
  json.extract! suggest_relationship, :id, :entity_instance_to, :entity_instance_from, :relationship_type_id, :url
  json.url suggest_relationship_url(suggest_relationship, format: :json)
end
