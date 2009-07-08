class Project < BasecampWrapper
  map_finders_to :projects
  has_many :todos, :milestones, :messages

  def self.find_active
    # This looks so odd
    find_all.find_all { |project| project.status != 'archived' }
  end  
end