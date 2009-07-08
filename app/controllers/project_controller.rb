class ProjectController < ApplicationController
  before_filter :load_project
  layout 'standard'
  
  def select_project
    redirect_to project_url(:id => params[:id])
  end
  
  def project
  end
end
