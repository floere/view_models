module ModulesInRenderHierarchy

  def self.included klass
    klass.extend ClassMethods
    klass.metaclass.alias_method_chain :include, :superclass_override
  end

  module ClassMethods
    def include_with_superclass_override mod
      original_superclass = superclass
      self.send :include_without_superclass_override, mod
      M.metaclass.send :define_method, :superclass do
        original_superclass
      end
      metaclass.send :define_method, :superclass do
        mod
      end
    end
  end

end