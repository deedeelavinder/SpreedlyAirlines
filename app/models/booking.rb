class Booking < ActiveRecord::Base
  belongs_to :user
  belongs_to :flight

  accepts_nested_attributes_for :flight
  accepts_nested_attributes_for :user

end
