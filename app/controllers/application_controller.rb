# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include LoginSystem

  before_filter :authenticate, :except => [:login, :authenticate, :logout]
  
  private
  
  def authenticate
    # Fetch the basecamp connection out of the session
    BasecampWrapper.basecamp = session[:bc]
    
    # Authenticate
    login_required(BasecampWrapper.basecamp)
  end
    
  def load_project
    @project = Project.find(params[:id])
    @page_title = "#{@project.company.name}: #{@project.name}"
  end
end
