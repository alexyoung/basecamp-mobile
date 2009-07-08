class Message < BasecampWrapper
  map_finders_to :message_list, :requires => :project
end