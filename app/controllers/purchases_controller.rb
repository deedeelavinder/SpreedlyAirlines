class PurchasesController < ApplicationController

  def new
    @purchase = Purchase.new
    @booking = Booking.find(params[:booking_id])
    @user = User.find(@booking.user_id)
  end

  def create
    @card = Card.find_by(token: params['token'])
    @booking = Booking.find(params[:booking_id])
    @purchase = Purchase.new(booking_id: @booking.id, card_id: @card.id)

    amount = @booking.flight.price
    retain = params['retain_payment_method']
    expedia_purchase = params['expedia']

    begin
      if expedia_purchase == 'true'
        @purchase.save! if @purchase.process_expedia_purchase(booking_id: @booking.id,
                                                              token: params['token'],
                                                              amount: amount,
                                                              retain: retain)
      else
        @purchase.save! if @purchase.process_purchase(token: params['token'],
                                                      amount: amount,
                                                      retain: retain)
      end

      if @purchase.save
        @booking.update(purchased: true)
        respond_to do |format|
          format.html { redirect_to @purchase, notice: 'Purchase was successful.' }
        end

      else
        raise 'This purchase was not successful. Please try again.'
        respond_to :html, :json
        redirect_to new_purchase_path
      end

    rescue => e
      puts e
    end

  end

  def show
    @purchase = Purchase.find(params['id'])
    @booking = Booking.find(@purchase.booking_id)
    @user_bookings = Booking.where(user_id: @booking.user_id)
    @user = User.find(@booking.user_id)
  end

  private

  def purchase_params
    params.require(:purchase).permit(:booking_id, :user, card: [:user_id, :token, :last_four])
  end


end
