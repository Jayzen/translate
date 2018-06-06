class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy, :set_weight]
  before_action :logged_in_user

  def index
    @tags = current_user.tags.unscoped.order("updated_at desc").page(params[:page])
    @tag = current_user.tags.build
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
  
    respond_to do |format|
      if @tag.save
        format.html { redirect_to tags_path, success: '单词分类创建成功' }
        format.js
      else
        format.html { redirect_to tags_path }
        format.js
      end
    end 
  end

  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to tags_path, success: '单词分类更新成功' }
        format.js
      else
        format.html { redirect_to tags_path }
        format.js
      end
    end 
  end

  def set_weight
    @tag.update(weight: Time.now)
    flash[:success] = "更新权重成功"
    redirect_to tags_path
  end

  def destroy
    @tag.destroy

    respond_to do |format|
      format.html { redirect_to tags_url, notice: 'Tag was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end 
  end

  private
    def set_tag
      @tag = current_user.tags.find(params[:id])
    end

    def tag_params
      params.require(:tag).permit(:name)
    end
end
