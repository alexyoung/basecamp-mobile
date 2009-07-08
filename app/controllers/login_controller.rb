class LoginController < ApplicationController
  layout 'standard'
  
  def login
    @page_title = 'Login'
  end
  
  # Authenticate using the basecamp API, and create a session object containing 
  # the authentication details.
  # 
  # This method uses an exception handler to try and give good user feedback
  # on login issues.
  def authenticate
    session[:bc] = nil
    
    begin
      BasecampWrapper.basecamp = Basecamp.new(params[:url].gsub(/http:\/\//, ''), params[:username], params[:password])

      # Test the login details are correct by accessing the API
      BasecampWrapper.basecamp.test_connection
      
      session[:bc] = BasecampWrapper.basecamp
      flash[:notice] = 'You are now logged in'
    rescue SocketError
      flash[:error] = 'Incorrect login details'
    rescue  Errno::EADDRNOTAVAIL, Errno::EBADF
      flash[:error] = 'Incorrect login details'
    rescue RuntimeError => message
      case message
        when /401/
          flash[:error] = 'Incorrect login details'
        when /403/
          flash[:error] = 'Please check the API is enabled for your account'
        when /404/
          flash[:error] = 'Incorrect login details'
      end
    rescue Errno::ECONNREFUSED
      flash[:error] = 'Connection refused.'
    end

    redirect_to '/'
  end
  
  def logout
    reset_session
    redirect_to '/'
  end
end
