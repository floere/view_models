module SpecHelperExtensions

  # Used to test private methods.
  #
  # The idea is to replace instance.send :private_method.
  # Now it is rather like:
  # We have the scenario we are in the given instance.
  #
  def in_the(instance, &block)
    instance.instance_eval(&block)
  end
  
end