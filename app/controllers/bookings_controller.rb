class BookingsController < ApplicationController

  def new
    @booking = Booking.new
    @flights = Flight.all
    @user = User.new
  end

  def create
    user_params = booking_params['user']
    @user = User.find_or_create_by(user_params)
    @booking = Booking.create(flight_id: params['flight_id'], user_id: @user.id)
    if @booking.save
      redirect_to new_purchase_path(booking_id: @booking.id)
    else
      raise 'Please try again.'
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:flight_id, user: [:first_name, :last_name, :email])
  end
end
