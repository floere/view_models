class User < ActiveRecord::Base
  attr_protected :created_at, :updated_at
end