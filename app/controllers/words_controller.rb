class WordsController < ApplicationController
  before_action :set_word, only: [:show, :edit, :update, :destroy, :status]
  before_action :logged_in_user

  def index
    @words = current_user.words.order("created_at desc").page(params[:page])
  end
  
  def lists
    @words = current_user.words.order("created_at desc").page(params[:page])
  end

  def status
    @word.toggle!(:status)

    respond_to do |format|
      format.js
    end
  end

  def search
    @words = current_user.words.where(name: params[:search].strip).page(params[:page])
    render 'index'
  end

  def familiar
    @words = current_user.words.where(status: true).page(params[:page])
    render 'index'
  end

  def unfamiliar
    @words = current_user.words.where(status: false).page(params[:page])
    render 'index'
  end

  def tags
    @words = current_user.words.where(tag_id: params[:tag_id]).page(params[:page])
    render 'index'
  end

  def interpret
    name = params[:name].strip
    if @word = Word.find_by(name: name)
      current_user.words << @word
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
          chinese: response.parsed_response["basic"]["explains"].map{|str| str.gsub(/\s+/, "")}.join(" "),
          us: response.parsed_response["basic"]["us-phonetic"]==nil ? nil : "["+response.parsed_response["basic"]["us-phonetic"]+"]",
          uk: response.parsed_response["basic"]["uk-phonetic"]==nil ? nil : "["+response.parsed_response["basic"]["uk-phonetic"]+"]"
        )
        redirect_to word_path(@word)
      end
    end
  end

  def show
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
      render :edit
    end
  end

  def destroy
    @word.destroy
    flash[:success] = "单词删除成功"
    redirect_to words_lists_path
  end

  private
    def set_word
      @word = current_user.words.find(params[:id])
    end

    def word_params
      params.require(:word).permit(:name, :uk, :us, :chinese, :tag_id)
    end
end
