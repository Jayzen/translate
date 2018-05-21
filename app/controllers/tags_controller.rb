class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user

  def index
    @tags = current_user.tags.order("created_at desc")
  end

  def show
  end

  def new
    @tag = current_user.tags.build
  end

  def edit
    render 'new'
  end

  def create
    @tag = current_user.tags.build(tag_params)
    if @tag.save
      flash[:success] = "单词分类创建成功"
      redirect_to tags_path
    else
      render :new
    end
  end

  def update
    if @tag.update(tag_params)
      flash[:success] = "单词分类更新成功"
      redirect_to tags_path
    else
      render :new
    end
  end

  def destroy
    @tag.destroy
    flash[:success] = "单词分类删除成功"
    redirect_to tags_path
  end

  private
    def set_tag
      @tag = current_user.tags.find(params[:id])
    end

    def tag_params
      params.require(:tag).permit(:name)
    end
end
