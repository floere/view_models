class SubSubclass
  
  attr_accessor :id
  
  attr_reader :some_untouched_attribute, :some_filtered_attribute, :some_doubly_doubled_attribute, :some_mangled_attribute
  
  def initialize
    @some_untouched_attribute      = :some_value
    @some_filtered_attribute       = '<script>filter me</script>'
    @some_doubly_doubled_attribute = 'blah'
    @some_mangled_attribute        = 'abcd'
  end
  
end