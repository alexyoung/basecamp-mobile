# A wrapper for the basecamp session object
class BasecampWrapper
  F = {}
  @finder_mapping = nil
  @@basecamp = nil
  
  cattr_accessor :basecamp
  
  def initialize(record = nil)
    @record = record
  end
  
  def self.metaclass; class << self; self; end; end
  
  # Store the finder mappings in an array
  def self.add_finder_mapping(remote_method) ; F[self.to_s] = remote_method ; end
  def self.finder_mapping(klass) ; F[klass] ;end

  # Returns the ID of this 'model'
  def id ; @record.id if @record ; end
  
  # Lazy load related objects
  #   class Project ; has_many :todos ; end
  #
  # project = Project.new(id)
  # project.todos => array of Todo objects
  #
  def self.has_many(*relationships)
    current_class = self.to_s.downcase
    
    relationships.each do |relationship|
      target_class = relationship.to_s.classify.constantize
    
      # Add a pluralized method name to this class to do the lazy loading (instance method)
      class_eval do
        define_method(relationship) do
          begin
            if @params
              target_class.send("find_all_by_#{target_class.instance_variable_get('@requires')}", send('id'), @params)
            else
              target_class.send("find_all_by_#{target_class.instance_variable_get('@requires')}", send('id'))
            end
          rescue
            []
          end
        end
      end
    
      # Add a find_all_by_ method to the class related to this one (class method)
      target_class.metaclass.instance_eval do
        define_method("find_all_by_#{current_class}") do |val|
          begin
            if @with_key
              @@basecamp.send(finder_mapping(target_class.to_s), val)[@with_key].collect { |record| self.new(record) }
            else
              @@basecamp.send(finder_mapping(target_class.to_s), val).collect { |record| self.new(record) }
            end
          rescue NoMethodError => error
            []
          end
        end
      end
    end
  end
  
  # This class requires a class to instantiate
  def self.requires(required_class)
    @requires = required_class
  end
  
  # Extract the results using a key on the returned hash
  def self.with_key(key)
    @with_key = key
  end
  
  # Send parameters to the method call
  def self.params(params)
    @params = params
  end
  
  # Map find and find_all to methods in another class.  self.new is used to
  # attempt to create objects with the type of the parent. 
  #
  # Add methods aliased by using:
  #   find_all :method_that_returns_list_of_this_type
  #
  # Pass :requires => :class to denote that this class requires another (Project > To do).
  # Pass :with_key => 'key name' to automatically extract values from a hash.
  #
  def self.map_finders_to(sym, args = {})
    add_finder_mapping(sym)
    requires(args[:requires]) if args.include? :requires
    with_key(args[:with_key]) if args.include? :with_key
    params(args[:params]) if args.include? :params
    
    class_eval do
      metaclass.instance_eval do
        define_method(:find_all) do
          @@basecamp.send(sym).collect { |record| self.new(record) }
        end
        
        define_method(:find) do |val|
          # Test it the baseclass has a method defined that looks like a finder
          sym_singular = sym.to_s.singularize
          if @@basecamp.respond_to? sym_singular
            self.new(@@basecamp.send(sym_singular, val))
          else
            # Attempt to load a set of values and pick one out
            if (record_id = val.to_i) > 0
              self.new(@@basecamp.send(sym).find { |record| record.id == record_id })
            else
              self.new(@@basecamp.send(sym).find(val))
            end
          end
        end
      end
    end
  end
  
  # Use this to map find_all to a method that returns data blindly
  def self.map_find_all_to(sym)
    add_finder_mapping(sym)
    class_eval do
      metaclass.instance_eval do
        define_method(:find_all) { @@basecamp.send(sym) }
      end
    end
  end
  
  protected
  
  def method_missing(sym, *args, &block)
    if @record.respond_to? sym
      @record.send(sym)
    elsif @@basecamp.respond_to?(sym)
      @@basecamp.send(sym, *args, &block)
    else
      super
    end
  end  
    
  def self.method_missing(sym, *args, &block)
    if @@basecamp.respond_to?(sym)
      @@basecamp.send(sym, *args, &block)
    else
      super
    end
  end  
end