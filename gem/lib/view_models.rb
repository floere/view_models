# TODO Switch to the right framework here.
#
# How would I recognize Padrino?
#
if defined?(Padrino)
  # Bundler.setup :padrino
  require File.join(File.dirname(__FILE__), '/padrino/init')
else
  require File.join(File.dirname(__FILE__), '/rails2/init')
end