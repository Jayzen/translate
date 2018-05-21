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
  
  def interpret
    appKey = Rails.application.credentials.dig(:development, :youdao_appKey)
    secretKey = Rails.application.credentials.dig(:development, :youdao_secretKey)
    myurl = 'https://openapi.youdao.com/api'
    q = params[:name].strip
    from = 'EN'
    to = 'zh-CHS'
    salt = Random.rand(10000).to_s
    sign = Digest::MD5.hexdigest(appKey+q+salt+secretKey).upcase

    url = myurl+"?q="+q+"&from="+from+"&to="+to+"&appKey="+appKey+"&salt="+salt+"&sign="+sign
    url = URI.escape(url)
    response = HTTParty.get(url)
    if (response.parsed_response["basic"] == nil) || !(/[a-zA-Z-]/ =~ q)
      flash[:danger] = "不存在该英文单词"
      redirect_to root_path
    else
      @word = current_user.words.find_or_create_by(
        name: q,
        chinese: response.parsed_response["basic"]["explains"].map{|str| str.gsub(/\s+/, "")}.join(" "),
        us: response.parsed_response["basic"]["us-phonetic"]==nil ? nil : "["+response.parsed_response["basic"]["us-phonetic"]+"]",
        uk: response.parsed_response["basic"]["uk-phonetic"]==nil ? nil : "["+response.parsed_response["basic"]["uk-phonetic"]+"]"
      )
      redirect_to word_path(@word)
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
