class Api::V1::RoomTypesController < Api::V1::ApiApplicationController
  skip_before_filter :load_filter 
  #set json as a default respons type
  respond_to :json

  def index
    room_types = RoomType.all
    render :status=>200, :json=>{:status=>"Success",:room_types => JSON.parse(room_types.to_json(:only=> [:id, :name, :price]))} rescue []
  end

end
