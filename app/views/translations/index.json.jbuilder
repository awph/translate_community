json.array!(@translations) do |translation|
  json.extract! translation, :id, :item_id, :language_id, :user_id, :value, :score
  json.url translation_url(translation, format: :json)
end
