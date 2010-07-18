if defined? Padrino
  require File.join(File.dirname(__FILE__), '/padrino/init')
else
  require File.join(File.dirname(__FILE__), '/rails2/init')
end