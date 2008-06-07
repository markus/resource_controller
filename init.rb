ActionController::Base.class_eval do
  include Urligence
  helper_method :smart_url
  
  extend ResourceController::ActionControllerExtension
end

# Subclasses of ActiveRecord::Base can override to_param_field
# or find_object. For example:
#   to_param_field :permalink
ActiveRecord::Base.class_eval do
  
  def self.to_param_field(name=nil)
    write_inheritable_attribute(:to_param_field, name) if name
    read_inheritable_attribute(:to_param_field)
  end
  
  to_param_field :id
  
  def self.find_object(id, parent=nil)
    conditions = {to_param_field => id}
    conditions["#{parent[0]}_id"] = parent[1].id if parent
    find(:first, :conditions => conditions) || (raise ActiveRecord::RecordNotFound, "Couldn't find #{self} with #{conditions.inspect}")
  end
  
end
