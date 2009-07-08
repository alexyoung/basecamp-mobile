class User < BasecampWrapper
  map_finders_to :people, :requires => :company
end