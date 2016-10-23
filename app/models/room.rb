class Room < ActiveRecord::Base

  has_many :bookings, :dependent => :destroy
  belongs_to :room_type
end
