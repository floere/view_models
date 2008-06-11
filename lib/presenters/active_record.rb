# Makes certain AR Model methods available to the presenter.
#
# Useful when the model is an AR Model.
#
class Presenters::ActiveRecord < Presenters::Base
  model_reader :to_param
end