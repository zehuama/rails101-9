class Account::PostsController < ApplicationController
  def index
    @posts = current_user.posts
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to account_posts_path, notice: "Update success!"
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to account_posts_path, alert: "Post Deleted."
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
