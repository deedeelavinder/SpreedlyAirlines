class User < ActiveRecord::Base
  has_many :bookings
  has_many :cards

  accepts_nested_attributes_for :bookings

  validates_presence_of :first_name, :last_name, :email
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create


  def cards(user)
    Card.all.where(user_id: user.id)
  end

  def full_name(user)
    user.first_name + ' ' + user.last_name
  end

  def has_saved_card?(user)
    cards(user).find_by(retained: true) ? true : false
  end

  def has_new_card?(user)
    cards(user).any? do |c|
	    c.retained == nil && !Purchase.find_by(card_id: c.id)
    end
  end

	def new_card(user)
		new_cards = []
		cards(user).each do |c|
			c.retained == nil && !Purchase.find_by(card_id: c.id) ? new_cards << c : nil
		end
		new_cards.first
	end

	def saved_cards(user)
		saved_cards = []
		saved_cards << cards(user).find_by(retained:true)
	end

end
