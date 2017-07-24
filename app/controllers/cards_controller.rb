class CardsController < ApplicationController

  def new
    @card = Card.new(token: params['payment_method_token'])
  end

  def create
    @booking = Booking.find(params['booking_id'])
    @user = User.find(@booking.user.id)
    @card = Card.create(token: params['payment_method_token'], user_id: @user.id)

    if @card.save
      redirect_to :back
    else
      raise 'Your payment method was not saved.  Please try again.'
      redirect_to new_purchase_path(booking_id: @booking.id)
    end
  end

  private

  def card_params
    params.require(:card).permit(:token, :user_id, :email, :booking_id)
  end

end
