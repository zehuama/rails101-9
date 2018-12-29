class Account::GroupsController < ApplicationController
  def index
    @groups = current_user.participated_groups
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to account_groups_path, notice: "修改成功！"
    else
      render :edit
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to account_groups_path, alert: "已删除。"
  end

  private

  def group_params
    params.require(:group).permit(:title, :description)
  end
end
