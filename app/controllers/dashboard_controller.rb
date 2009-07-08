class DashboardController < ApplicationController
  layout 'standard'
  
  def index
    @page_title = 'Dashboard'
  end
end
