class Booking < ActiveRecord::Base
  belongs_to :room
  belongs_to :user
  
  attr_accessor :room_type_id 
  validates :room_type_id,:start_date ,:end_date, presence: true
  validate :availability_of_room, :time_period_for_room_reservation
  after_create :assign_room, :calculate_total_amount
  
  #this customvalidatiom validation check room is avaible or not when user book the room
  def availability_of_room
    room_type = RoomType.find(self.room_type_id) rescue nil
    errors.add(:room_type_id, "Pleass select room type") if room_type.blank?
    return if room_type.blank?
    total_rooms = room_type.rooms.pluck(:id)
    booked_rooms = Booking.where('(start_date >= ? and start_date <= ?) or (end_date >= ? and end_date <= ?)', self.start_date, self.end_date, self.start_date, self.end_date).pluck(:room_id)
    available_rooms = total_rooms - booked_rooms
    errors.add(:start_date, "unavailable for given time period") if available_rooms.count == 0
  end  
  
  #this custom validation check when user book room before 6 month to check in date
  def time_period_for_room_reservation
    time_period = (self.start_date.year * 12 + self.start_date.month) - (Date.today.year * 12 + Date.today.month)
    errors.add(:start_date, "you can book your room before 6 months only") if time_period > 6
  end  
  
  # when user book room this method assign_room to user
  def assign_room
    total_rooms, available_rooms = [], []
    room_type = RoomType.find(self.room_type_id)
    total_rooms = room_type.rooms.pluck(:id)
    booked_rooms = Booking.where('(start_date >= ? and start_date <= ?) or (end_date >= ? and end_date <= ?)', self.start_date, self.end_date, self.start_date, self.end_date).pluck(:room_id)
    available_rooms = total_rooms - booked_rooms
    self.update_column(:room_id, available_rooms.first)
  end  

  # when user book room this method calculate_total_amount
  def calculate_total_amount
    total_days = (self.end_date - self.start_date).to_i
    self.update_column(:total_amount, total_days * self.room.room_type.price)
  end

 # search room is avaible or not this method work on web side and api side
  def self.search(data, value)
    if value == "web"
      type, check_in, check_out = data[:room_type], data[:check_in], data[:check_out]
      return if type.blank? or check_in.blank?
    else
      type, check_in, check_out = data[0], data[1], data[2]
    end  
    total_rooms, available_rooms = [], []
    room_type = RoomType.find_by_name(type) rescue nil
    total_rooms = room_type.rooms.pluck(:id)
    booked_rooms = Booking.where('(start_date >= ? and start_date <= ?) or (end_date >= ? and end_date <= ?)', check_in, check_out, check_in, check_out).pluck(:room_id)
    available_rooms = total_rooms - booked_rooms
    # available_rooms = Room.where(:id => available_rooms).map{|r| [r.id, r.room_no]}
    room_count_and_price = [available_rooms.count, room_type.price]
    return room_count_and_price
  end

  def available_rooms
    total_rooms = self.rooms.pluck(:id)
    booked_rooms = Booking.where('(start_date >= ? and start_date <= ?) or (end_date >= ? and end_date <= ?)', check_in, check_out, check_in, check_out).pluck(:room_id)
    available_rooms = total_rooms - booked_rooms
    # available_rooms = Room.where(:id => available_rooms).map{|r| [r.id, r.room_no]}
    room_count_and_price = [available_rooms.count, room_type.price]
    return room_count_and_price
  end  

end
