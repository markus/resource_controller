# Nested and Polymorphic Resource Helpers
#
module ResourceController::Helpers::Nested
  protected
    
    # Returns the type of the current parent
    #
    def parent_types
      @parent_types ||= [*belongs_to].reject(&:nil?).
                          map { |parent_type| [*parent_type] }.
                            detect { |parent_type| parent_type.all? { |parent| !parent_param(parent).nil? } }
    end
    
    # Returns true/false based on whether or not a parent is present.
    #
    def parent?
      !parent_types.nil?
    end
    
    # Returns the current parent param, if there is a parent. (i.e. params[:post_id])
    def parent_param(type)
      params["#{type}_id".to_sym]
    end
    
    def parent_objects
      @parent_objects ||= parent_types.inject([]) do |parent_objects, type|
        parent_objects << [type, parent_model_for(type).find_object(parent_param(type), parent_objects.last)]
      end
    end
    
    def parent_model_for(type)
      type.to_s.classify.constantize
    end
    
    # If there is a parent, returns the relevant association proxy.  Otherwise returns model.
    #
    def end_of_association_chain
      parent? ? parent_objects.last.last.send(model_name.to_s.pluralize.intern) : model
    end
end
