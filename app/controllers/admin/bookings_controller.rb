class Admin::BookingsController < ApplicationController
  before_filter :authenticate_admin
  layout "admin/admin"
  
  def index
    @bookings = Booking.includes(:user,:room).order("created_at desc")
  end
end
