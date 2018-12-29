class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_group
  before_action :member_required, only: [:new, :create]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.group = @group
    @post.user = current_user
    if @post.save
      redirect_to group_path(@group), notice: "新增文章成功！"
    else
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    if current_user != @post.user
      redirect_to group_path(@group), alert: "You have no permission."
    end
  end

  def update
    @post = Post.find(params[:id])
    if current_user != @post.user
      redirect_to group_path(@group), alert: "You have no permission."
    end
    if @post.update(post_params)
      redirect_to group_path(@group), notice: "文章已更新！"
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if current_user != @post.user
      redirect_to group_path(@group), alert: "You have no permission."
    end
    @post.destroy
    redirect_to group_path(@group), alert: "文章已删除。"
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end

  def find_group
    @group = Group.find(params[:group_id])
  end

  def member_required
    if !current_user.is_member_of?(@group)
      redirect_to group_path(@group), warning: "你不是本讨论版成员，不能发文哦！"
    end
  end
end
