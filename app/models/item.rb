class Item < ActiveRecord::Base
  attr_accessible :name, :price, :user_id, :description, :user_name

	belongs_to :user
end
