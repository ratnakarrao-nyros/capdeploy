node(:total_lists_count) { @lists.total_entries }
node(:posted_at) { |l| time_ago_in_words(l.created_at).concat(" ago") }

collection @lists
attributes :id, :name, :description, :state
