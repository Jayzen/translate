class WordsController < ApplicationController
  before_action :set_word, only: [:show, :edit, :update, :destroy, :status]
  before_action :logged_in_user

  def index
    @words = current_user.words.order("updated_at desc").page(params[:page]).per(12)
  end

  def autocomplete
    @words = current_user.words.where(["name like ?", "%#{params[:term]}%"])
      .order("created_at desc").page(params[:page])
  end

  def lists
    @words = current_user.words.order("updated_at desc").page(params[:page])
  end

  def status
    @word.toggle!(:status)

    respond_to do |format|
      format.js
    end
  end

  def unfamiliar
    @words = current_user.words.order("updated_at desc").where(status: false).page(params[:page])
    render 'index'
  end

  def categories
    @words = current_user.words.order("updated_at desc").where(category_id: params[:category_id]).page(params[:page])
    render 'index'
  end

  def interpret
    name = params[:name].strip
    category_id = params[:word][:category_id]
    if @word  = current_user.words.find_by(name: name)
      @word.update(updated_at: Time.now, category_id: category_id)
      redirect_to word_path(@word)
    elsif @word  = Word.find_by(name: name)
      @word = current_user.words.create(
        name: @word.name,
        uk: @word.uk,
        us: @word.us,
        chinese: @word.chinese,
        uk_voice: @word.uk_voice,
        us_voice: @word.us_voice,
        category_id: category_id
      )
      redirect_to word_path(@word)
    else
      response = Word.translate(name)
      if response == "net_error" 
        flash[:danger] = "翻译功能暂时不能用"
        redirect_to root_path
      elsif (response.parsed_response["basic"] == nil) || !(/[a-zA-Z-]/ =~ name)
        flash[:danger] = "不存在该英文单词"
        redirect_to root_path
      else
        @word = current_user.words.create(
          name: name,
          category_id: category_id,
          chinese: response.parsed_response["basic"]["explains"].map{|str| str.gsub(/\s+/, "")}.join(" "),
          us: response.parsed_response["basic"]["us-phonetic"]==nil ? nil : "["+response.parsed_response["basic"]["us-phonetic"]+"]",
          uk: response.parsed_response["basic"]["uk-phonetic"]==nil ? nil : "["+response.parsed_response["basic"]["uk-phonetic"]+"]",
          uk_voice: response.parsed_response["basic"]["uk-speech"],
          us_voice: response.parsed_response["basic"]["us-speech"]
        )
        redirect_to word_path(@word)
      end
    end
  end

  def show
    respond_to do |format|
      format.js { render 'show' }
      format.html
    end
  end

  def new
    @word = current_user.words.build
  end

  def edit
    render 'new'
  end

  def create
    @word = current_user.words.build(word_params)
    if @word.save
      flash[:success] = "单词创建成功"
      redirect_to words_lists_path
    else
      render :new
    end
  end

  def update
    if @word.update(word_params)
      flash[:success] = "单词更新成功"
      redirect_to words_lists_path
    else
      render :new
    end
  end

  def destroy
    @word.destroy
    flash[:success] = "单词删除成功"
    redirect_to words_lists_path
  end

  def remove_select
    unless params[:word_ids].nil?
      current_user.words.where(id: params[:word_ids]).destroy_all #不能使用delete_all,其不会更新关联项
      redirect_to words_lists_path
      flash[:success] = '选中的单词被全部删除!'
    else
      redirect_to words_lists_path
      flash[:danger] = "单词未被选择!"
    end
  end 

  private
    def set_word
      @word = current_user.words.find(params[:id])
    end

    def word_params
      params.require(:word).permit(:name, :uk, :us, :chinese, :tag_id)
    end
end
