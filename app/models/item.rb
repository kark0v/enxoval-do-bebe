class Item < ActiveRecord::Base
  attr_accessible :name, :price, :user_id, :description

	belongs_to :user
end
