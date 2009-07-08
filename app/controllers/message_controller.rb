class MessageController < ApplicationController
  before_filter :load_project
  layout 'standard'
  
  def index
  end
  
  def create
    Message.post_message(@project.id, { :title => params[:title], :body => params[:body], :category_id => params[:category_id], :private => params[:private] || 0 })
    flash[:notice] = 'Message posted'
    redirect_to project_url(:id => @project.id)
  end
end
