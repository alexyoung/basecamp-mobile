class Milestone < BasecampWrapper
  map_finders_to :milestones, :requires => :project
end