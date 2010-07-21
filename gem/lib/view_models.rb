def rails3?
  Rails && Rails.version >= '3.0.0'
end

if defined? Padrino
  require File.join(File.dirname(__FILE__), '/padrino/init')
else
  if rails3?
    require File.join(File.dirname(__FILE__), '/rails3/init')
  else
    require File.join(File.dirname(__FILE__), '/rails2/init')
  end
end