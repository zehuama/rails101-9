class GroupsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user
    if @group.save
      current_user.join!(@group)
      redirect_to groups_path, notice: "新增讨论版成功！"
    else
      render :new
    end
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts
  end

  def edit
    @group = Group.find(params[:id])
    if current_user != @group.user
      redirect_to groups_path, alert: "You have no permission."
    end
  end

  def update
    @group = Group.find(params[:id])
    if current_user != @group.user
      redirect_to groups_path, alert: "You have no permission."
    end
    if @group.update(group_params)
      redirect_to groups_path, notice: "修改讨论版成功！"
    else
      render :edit
    end
  end

  def destroy
    @group = Group.find(params[:id])
    if current_user != @group.user
      redirect_to groups_path, alert: "You have no permission."
    end
    @group.destroy
    redirect_to groups_path, alert: "讨论版已删除"
  end

  def join
    @group = Group.find(params[:id])
    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "加入本讨论版成功！"
    else
      flash[:warning] = "你已经是本讨论版成员！"
    end
    redirect_to group_path(@group)
  end

  def quit
    @group = Group.find(params[:id])
    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
      flash[:alert] = "已退出本讨论版。"
    else
      flash[:warning] = "你不是本讨论版成员，无法退出。"
    end
    redirect_to group_path(@group)
  end

  private

  def group_params
    params.require(:group).permit(:title, :description)
  end
end
