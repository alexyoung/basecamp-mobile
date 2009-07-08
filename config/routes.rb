ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  
  map.dashboard '', :controller => 'dashboard', :action => 'index'
  map.connect 'login', :controller => 'login', :action => 'login'
  map.connect 'authenticate', :controller => 'login', :action => 'authenticate'
  map.logout  'logout', :controller => 'login', :action => 'logout'

  map.project 'projects/:id', :controller => 'message', :action => 'index'
  map.project_select 'project_select/', :controller => 'project', :action => 'select_project'
  
  map.todos 'projects/:id/todos', :controller => 'list', :action => 'index'
  map.complete_todo 'projects/:id/todos/:todo_id', :controller => 'list', :action => 'complete'
  map.create_todo 'projects/:id/todos/:todo_id/create', :controller => 'list', :action => 'create'
  
  map.create_milestone 'projects/:id/milestone/create', :controller => 'milestone', :action => 'create'
  map.milestones 'projects/:id/milestones', :controller => 'milestone', :action => 'index'
  map.complete_milestone 'projects/:id/milestones/:milestone_id/complete', :controller => 'milestone', :action => 'complete'
  
  map.post_message 'projects/:id/create_message', :controller => 'message', :action => 'create'

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
end
