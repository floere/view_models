class SubSubclass
  
  attr_reader :some_untouched_attribute, :some_filtered_attribute
  
  def initialize
    @some_untouched_attribute = :some_value
    @some_filtered_attribute  = '<script>filter me</script>'
  end
  
end