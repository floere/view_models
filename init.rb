# TODO Switch to the right framework here.
#
# How would I recognize Padrino?
#
if defined?(Padrino)
  # Padrino
  #
  require File.dirname(__FILE__) + '/padrino/init'
else
  # Rails
  #
  require File.dirname(__FILE__) + '/rails/init'
end