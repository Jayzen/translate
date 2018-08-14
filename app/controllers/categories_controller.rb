class CategoriesController < ApplicationController
  before_action :logged_in_user
  before_action :find_category, only: [:edit, :update, :destroy, :delete, :set_weight]

  def index
    @categories = current_user.categories.page(params[:page]).per(10) 
    @categories_all = current_user.categories
  end

  def new
    @category = current_user.categories.build
  end

  def create
    @category = current_user.categories.build(category_params)
    respond_to do |format|
      if @category.save
        format.js do
          @categories = current_user.categories.page(params[:page]).per(10)
          @categories_all = current_user.categories
          render 'create', status: :created
        end
      else
        format.js { render 'new', status: :unprocessable_entity }
      end
    end
  end
  
  def edit
  end

  def update
    respond_to do |format|
      if @category.update(category_params)
        format.js do
          @categories_all = current_user.categories
          render 'update', status: :ok
        end
      else
        format.js { render 'edit', status: :unprocessable_entity}
      end
    end
  end

  def destroy
    @category.destroy
    respond_to do |format|
      format.js do 
        @categories = current_user.categories.page(params[:page]).per(10)
        @categories_all = current_user.categories
      end
    end
  end

  def delete
  end

  def set_weight
    @category.update(weight: Time.now)
    respond_to do |format|
      format.js do 
        @categories = current_user.categories.page(params[:page]).per(10)
        @categories_all = current_user.categories
      end
    end
  end

  private
    def category_params
      params.require(:category).permit(:name, :weight)
    end

    def find_category
      @category = current_user.categories.find(params[:id])
    end
end
