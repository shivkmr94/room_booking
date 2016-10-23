class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :bookings, :dependent => :destroy

  before_create :ensure_authentication_token, :generate_key
 
  def generate_key
    self.key = self.get_secret_key
  end

  def booking_details
    @bookings = self.bookings.includes(:room).order("created_at desc")
    booking_response = []
    if @bookings.present?
      @bookings.each do |booking|
        data = {"booking_id" => booking.id ,"room_type" => booking.room.room_type.name,"room_no" => booking.room.room_no, "total_amount" => booking.total_amount, "check_in" => booking.start_date, "check_out" => booking.end_date}
        data.each {|k, v| v.nil? ? data[k] = '' : data[k] = v}
        booking_response << data
      end  
    end
    return booking_response 
  end


  def ensure_authentication_token
    
    if authentication_token.blank?
      self.authentication_token = self.generate_authentication_token
    end
  end

  def get_secret_key
    binding.pry
    key = Digest::SHA1.hexdigest(BCrypt::Engine.generate_salt)
    Digest::SHA1.hexdigest(self.email.to_s + self.encrypted_password.to_s + key)
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end        

end
