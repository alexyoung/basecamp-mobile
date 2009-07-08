class TodoItem < BasecampWrapper
  map_finders_to :get_list, :requires => :todo, :with_key => 'todo-items', :params => [false]
end