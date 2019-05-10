class RoomsController < ApplicationController
  before_action :authenticate_user!
  
  # room_cd をキーにしてやるのもあり
  # SecureRandom.hex でキーを発行する
  
  def index
    @rooms = Room.where(id: RoomMember.where(user: current_user).map(&:room_id))
  end
  
  def show
    @room = Room.find(RoomMember.find_by(user: current_user, id: params[:id]).id)
    @message = @room.messages.new
  end
  
  def new
    @room = Room.new
  end
  
  def create
    @room = Room.new
    # ユーザーを取得して保存
    # 自分のレコードと相手のレコードを保存する
    to_user = User.find_by(email: params[:room][:email])
    if to_user.blank?
      flash.now[:alert] = "入力されたメールアドレスは存在しません。"
      render action: :new
    elsif to_user == current_user
      # 何もしない
      flash.now[:alert] = "自分以外のアドレスを入力してください。"
      render action: :new
    else
      # データ作成
      @room = Room.new(name: to_user.email)
      @room.room_members.new(user: current_user)
      @room.room_members.new(user: to_user)
      if @room.save
        redirect_to rooms_path, notice: "部屋を作成しました。"
      else
        flash.now[:alert] = "チャットルームの作成に失敗しました。"
        render action: :new
      end
    end
  end
  
  private
  def rooms_params
    params.require(:room).permit(:name)
  end
end
