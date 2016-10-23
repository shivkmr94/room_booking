class Admin::RoomTypesController < ApplicationController
  
  before_filter :authenticate_admin
  before_filter :find_room_type, :except => [:index]
  layout "admin/admin"
  
  def index
    @room_types = RoomType.all.order("created_at desc")
  end 

  def new
    @room_type = RoomType.new
  end

  def create
    @room_type = RoomType.new(room_type_params)
    if @room_type.save
      redirect_to admin_room_types_path
    else
      render 'new'
    end
  end

  def edit
  end 

  def show
  end  

  def update
    if @room_type.update_attributes(room_type_params)
      redirect_to admin_room_types_path
    else
      render :action => "edit"
    end
  end 

  def destroy
    if @room_type.destroy
      redirect_to admin_room_types_path
    end
  end

  protected

  def find_room_type
    @room_type = RoomType.find(params[:id]) rescue nil
  end
  
  def room_type_params
    params.require(:room_type).permit!
  end
end
