class User::BookingsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  before_filter :find_booking, :except => [:index]
  before_filter :set_search_session, :only => [:index]
  layout "user/user"
  respond_to :html

  def index
    @bookings = Booking.includes(:room).where("user_id =?", current_user.id).order("created_at desc") if current_user.present?
    @avaible_room = Booking.search(params, "web") if params[:search].present?
  end  

  def new
    @booking = current_user.bookings.build 
  end

  def create
    @booking = current_user.bookings.build(booking_params)
    @booking.room_type_id = RoomType.find_by_name(params[:booking][:room_type_id]).id
    if @booking.save
      redirect_to user_bookings_path
    else
      render 'new'
    end
  end

  def edit
  end 

  def show
  end  

  def update
    if @booking.update_attributes(booking_params)
      redirect_to user_bookings_path
    else
      render :action => "edit"
    end
  end 

  def destroy
    if @booking.destroy
      redirect_to user_bookings_path
    end
  end

  protected

  def find_booking
    @booking = Booking.find(params[:id]) rescue nil
  end
  
  def booking_params
    params.require(:booking).permit!
  end

  def set_search_session
    if params[:search].present?
      session[:user_search] = params
    end
  end

end
