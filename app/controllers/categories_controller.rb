class CategoriesController < ApplicationController
  before_action :logged_in_user
  
  def index
    @categories = current_user.categories 
  end

  def new
    @category = current_user.categories.build
  end

  def create
    @category = current_user.categories.build(category_params)
    respond_to do |format|
      if @category.save
        format.js do
          @categories = current_user.categories
          render 'create', status: :created
        end
        format.html do
          flash[:success] = "Contact was successfully created."
          redirect_to categories_path
        end
      else
         format.js { render 'new', status: :unprocessable_entity }
         format.html do
           flash[:error] = "Contact failed to be created."
           render 'new'
         end
      end
    end
  end
  
  def edit
    @category = current_user.categories.find(params[:id])
  end

  def update
    @category = current_user.categories.find(params[:id])
    respond_to do |format|
      if @category.update(category_params)
        format.js { render 'update', status: :ok}
      else
        format.js { render 'edit', status: :unprocessable_entity}
      end
    end
  end

  def destroy
    @category = current_user.categories.find(params[:id])
    @category.destroy
    respond_to do |format|
      format.js { @categories = current_user.categories }
    end
  end

  def delete
    @category = current_user.categories.find(params[:id])
  end

  def set_weight
    @category = current_user.categories.find(params[:id])
    @category.update(weight: Time.now)
    respond_to do |format|
      format.js { @categories = current_user.categories }
    end
  end

  private
    def category_params
      params.require(:category).permit(:name, :weight)
    end
end
