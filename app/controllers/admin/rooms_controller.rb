class Admin::RoomsController < ApplicationController
  
  before_filter :authenticate_admin
  before_filter :find_room, :except => [:index]
  layout "admin/admin"
  
  def index
    @rooms = Room.includes(:room_type).order("created_at desc")
  end 

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      redirect_to admin_rooms_path
    else
      render 'new'
    end
  end

  def edit
  end 

  def show
  end  

  def update
    if @room.update_attributes(room_params)
      redirect_to admin_rooms_path
    else
      render :action => "edit"
    end
  end 

  def destroy
    if @room.destroy
      redirect_to admin_rooms_path
    end
  end

  protected

  def find_room
    @room_type = Room.find(params[:id]) rescue nil
  end
  
  def room_params
    params.require(:room).permit!
  end
end


