class ListController < ApplicationController
  before_filter :load_project
  layout 'standard'
  
  def index
    @page_title = 'List'
    @todos = {}
    @list_items = {}
    
    @project.todos.each do |todo|
      show_list = false
      
      todo.todo_items.sort {|x, y| x.completed.to_s <=> y.completed.to_s }[0..5].each do |list_item|
        @list_items[todo.id] ||= []
        @list_items[todo.id].push list_item
        show_list = true if not list_item.completed
      end
      
      @todos[todo.id] = todo if show_list
    end
  end
  
  def complete
    Todo.complete_item(params[:todo_id])
    flash[:notice] = 'To do item completed'
    redirect_to todos_url(:id => @project.id)
  end

  def create
    Todo.create_item(params[:todo_id], params[:content])
    flash[:notice] = 'Message posted'
    redirect_to todos_url(:id => @project.id)
  end
end
