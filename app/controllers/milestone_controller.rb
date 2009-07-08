class MilestoneController < ApplicationController
  before_filter :load_project
  layout 'standard'
  
  def index
    @milestones = @project.milestones
  end

  def complete
    Milestone.complete_milestone(@params[:milestone_id])
    flash[:notice] = 'Milestone completed'
    redirect_to milestones_url(:id => @project.id)
  end
  
  def create
    Milestone.create_milestone(params[:id], {:title => params[:milestone][:title], :deadline => "#{params[:milestone]["deadline(1i)"]}/#{params[:milestone]["deadline(2i)"]}/#{params[:milestone]["deadline(3i)"]}".to_date})
    flash[:notice] = 'Milestone created'
    redirect_to milestones_url(:id => @project.id)
  end
end
