class Api::V1::BookingsController < Api::V1::ApiApplicationController
  before_filter :load_filter 
  before_filter :filter_out_request
  #set json as a default respons type
  respond_to :json

  def index
    user_booking_details = current_user.booking_details if current_user.present?
    data = [params[:room_type], params[:check_in], params[:check_out]]
    room_availability_details = Booking.search(data, "api") if data.present?
    if user_booking_details.present? and room_availability_details.present?
      render :json => {:room_availibility => [{:room_type => params[:room_type], :check_in => params[:check_in], :check_out => params[:check_out],:no_of_room => room_availability_details.first, :price_per_room => room_availability_details.last}],:total_time_room_book => user_booking_details.count, :booking_details => user_booking_details}
    elsif room_availability_details.present?
      render :json => {:room_availibility => [{:room_type => params[:room_type], :check_in => params[:check_in], :check_out => params[:check_out],:no_of_room => room_availability_details.first, :price_per_room => room_availability_details.last}]}
    elsif user_booking_details.present?
      render :json => { :user => current_user.email,:total_time_room_book => user_booking_details.count, :booking_details => user_booking_details}
    end  
  end

  def create
    @room_type = RoomType.find_by_id(params[:room_type])
    if @room_type.present?
      @booking = current_user.bookings.build(:room_type_id => @room_type.id, :start_date => params[:check_in], :end_date => params[:check_out], :user_id => current_user.id)
      if @booking.save
        render :status=>200, :json=>{:status=>"Success", :message=>"You have Successfully booked room."} and return
      else
        render :status => 200, :json => { :status=>"Failure",:message=>"Room booking Failed Error: #{@booking.errors.values.join(", ")}."}
      end
    else
      render :status=>404, :json=>{:status=>"Failure", :status_code => 404, :message=>"Please check room_type."}
    end
  end

  protected

  def filter_out_request
    render :status=>200,:json=>{:status=>200,:message=>"The request must contain check_in, check_out and room_type."} and return if (params[:room_type].blank? or params[:check_in].blank? or params[:check_out].blank?)
    render :status=>200,:json=>{:status=>200,:message=>"Check in, Check out can't be past time."} and return if (params[:check_in].to_date < Date.today  or params[:check_out].to_date < Date.today)
    render :status=>200,:json=>{:status=>200,:message=>"Check in, Check out can't be more than 6 month."} and return if ((params[:check_in].to_date > Date.today + 6.month) or (params[:check_out].to_date > Date.today + 6.month))
  end 
   
end
