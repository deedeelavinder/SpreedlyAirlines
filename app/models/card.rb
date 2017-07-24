class Card < ActiveRecord::Base
  has_many :purchases
  belongs_to :user

  validates :token, uniqueness: true

end
