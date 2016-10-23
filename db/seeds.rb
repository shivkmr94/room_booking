RoomType.destroy_all
Room.destroy_all
Booking.destroy_all
User.destroy_all

users =[["admin@hoteldomain.com","password","password",true],
		["shiv@example.com","password","password",false],
	    ["nitin@example.com","password","password",false],
      ["rakesh@example.com","password","password",false],
      ["aman@example.com","password","password",false],
      ["vikash@example.com","password","password",false]]
 users.each do |email,password, password_confirmation, admin|
 	User.create!(email: email, password: password, password_confirmation: password_confirmation, admin: admin)
	
end

room_types = [
  [ "Deluxe Rooms - Queen Size Bed", 7000 ],
  [ "Luxury Rooms - Queen Size Bed and Pool Facing", 8500 ],
  [ "Luxury Suites - King Size Bed and Pool Facing", 12000 ],
  [ "Presidential Suites - King Size Bed, Pool Facing with a Gym", 20000 ]
]

room_types.each do |name, price|
  RoomType.create( name: name, price: price )
end

rooms = [
  [ "A01", 1 ],[ "A02", 1 ],[ "A03", 1 ],[ "A04", 1 ],[ "A05", 1 ],
  [ "B01", 1 ],[ "B02", 1 ],[ "B03", 1 ],[ "B04", 1 ],[ "B05", 1 ],
  [ "C01", 1 ],[ "C02", 1 ],[ "C03", 1 ],[ "C04", 1 ],[ "C05", 1 ],
  [ "D01", 1 ],[ "D02", 1 ],[ "D03", 1 ],[ "D04", 1 ],[ "D05", 1 ],

  [ "A06", 2 ],[ "A07", 2 ],[ "A08", 2 ],[ "A09", 2 ],[ "A10", 2 ],
  [ "B06", 2 ],[ "B07", 2 ],[ "B08", 2 ],[ "B09", 2 ],[ "B10", 2 ],
  [ "C06", 2 ],[ "C07", 2 ],[ "C08", 2 ],[ "C09", 2 ],[ "C10", 2 ],
  [ "D06", 2 ],[ "D07", 2 ],[ "D08", 2 ],[ "D09", 2 ],[ "D10", 2 ],

  [ "D11", 3 ],[ "D12", 3 ],[ "D13", 3 ],[ "D14", 3 ],[ "D15", 3 ],
  [ "D16", 3 ],[ "D17", 3 ],[ "D18", 3 ],[ "D19", 3 ],[ "D20", 3 ],[ "E01", 3 ],[ "E02", 3 ],

  [ "E03", 4 ],[ "E04", 4 ],[ "E05", 4 ],[ "E06", 4 ],[ "E07", 4 ],[ "E08", 4 ],[ "E09", 4 ],[ "E10", 4 ]
]

rooms.each do |room_no, room_type_id|
  Room.create( room_no: room_no, room_type_id: room_type_id )
end
