class Subscriber < ApplicationRecord
  validates :phone_number, presence: true
end
