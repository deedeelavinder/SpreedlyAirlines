require 'net/http'

class Purchase < ActiveRecord::Base
	include HTTParty

	belongs_to :booking
	belongs_to :card

	GATEWAY_TOKEN = ApplicationController::GATEWAY_TOKEN
	EXPEDIA_TOKEN = ApplicationController::EXPEDIA_TOKEN
	SPREEDLY_KEY = ApplicationController::SPREEDLY_KEY
	SPREEDLY_SECRET = ApplicationController::SPREEDLY_SECRET


	def process_purchase(token:, amount:, retain:)
		base_url = 'https://core.spreedly.com/v1/gateways/'
		purchase_url = base_url + GATEWAY_TOKEN + "/purchase.json"
		authorization = {username: SPREEDLY_KEY, password: SPREEDLY_SECRET}

		transaction = {
				payment_method_token: token,
				amount: amount,
				currency_code: 'USD',
				retain_on_success: retain
		}
		response = HTTParty.post(purchase_url,
		                         {
				                         headers: {'Content-Type' => 'application/json'},
				                         basic_auth: authorization,
				                         body: {transaction: transaction}.to_json
		                         })
		puts response.parsed_response
		parse_response(response: response, token: token, retain: retain)
	end

	def process_expedia_purchase(booking_id:, token:, amount:, retain:)
		base_url = 'https://core.spreedly.com/v1/receivers/'
		delivery_url = base_url + EXPEDIA_TOKEN + "/deliver.json"
		authorization = {username: SPREEDLY_KEY, password: SPREEDLY_SECRET}

		delivery = {
				payment_method_token: token,
				url: "https://book.api.ean.com",
				body: {
						booking_id: booking_id,
						card_number: "{{credit_card_number}}",
						amount: amount,
						retain_on_success: retain
				}
		}
		response = HTTParty.post(delivery_url,
		                         {
				                         headers: {'Content-Type' => 'application/json'},
				                         basic_auth: authorization,
				                         body: {delivery: delivery}.to_json
		                         })
		puts response.parsed_response
		puts response['transaction']['token']

		true
	end

	private

	def parse_response(response: response, token: token, retain: retain)
		success = response.parsed_response['transaction']['succeeded']
		retained = ActiveRecord::Type::Boolean.new.type_cast_from_user(retain)
		update_card(response: response, token: token, retained: retained) if success
		success
	end

	def update_card(response:, token:, retained:)
		card = Card.find_by(token: token)
		last_four_digits = response.parsed_response['transaction']['payment_method']['last_four_digits']
		card.update(last_four: last_four_digits, retained: retained)
	end

end
