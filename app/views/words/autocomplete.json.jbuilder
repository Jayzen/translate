json.array!(@words) do |word|
  json.id word.id
  json.value word.name
end
