class Flight < ActiveRecord::Base
  has_many :bookings

  def flight_info
    destination + ':' + ' $' + sprintf("%.2f", price).to_s
  end

end
