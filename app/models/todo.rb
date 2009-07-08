class Todo < BasecampWrapper
  map_finders_to :lists, :requires => :project
  has_many :todo_items
end