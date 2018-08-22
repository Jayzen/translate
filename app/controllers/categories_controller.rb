class CategoriesController < ApplicationController
  before_action :logged_in_user
  before_action :find_category, only: [:edit, :update, :destroy, :delete, :set_weight]
  before_action :find_categories_all, only: [:index, :create, :update, :destroy, :set_weight]

  def index
    session[:categories_page] = (params[:page]==nil ? 1 : params[:page])
    @categories = current_user.categories.page(params[:page]).per(10) 
  end

  def new
    @category = current_user.categories.build
  end

  def create
    @category = current_user.categories.build(category_params)
    respond_to do |format|
      @category.weight = Time.now
      if @category.save
        #format.json必须放在format.js的前面
        format.json { render json: @category, status: :created }
        format.js do
          @categories = current_user.categories.page(1).per(10)
          render 'create', status: :created
        end
      else
        format.json { render json: @category.errors.full_messages, status: :unprocessable_entity}
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
        @categories = current_user.categories.page(session[:categories_page]).per(10)
      end
    end
  end

  def delete
  end

  def set_weight
    @category.update(weight: Time.now)
    respond_to do |format|
      format.js do 
        @categories = current_user.categories.page(1).per(10)
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

    def find_categories_all
      #获取categories_all来判断是否为第一权重
      @categories_all = current_user.categories
    end
end
