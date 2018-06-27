class CsvsController < ApplicationController
  before_action :logged_in_user
  
  def index
    @words = current_user.words
    respond_to do |format|
      format.html
      format.csv { send_data @words.to_csv(['name', 'chinese', 'uk', 'us']) }
    end 
  end

  def import
    if params[:file].nil?
      flash[:danger] = "不能上传空文件"
    elsif !params[:file].nil? && params[:file].path !~ /.+\.csv$/
      flash[:danger] = "只能上传csv格式的文件"
    else !params[:file].nil? && params[:file].path =~ /.+\.csv$/
      words = Word.import(params[:file])
      words.each do |word|
        begin
          new_word = current_user.words.find_or_create_by(word)
          new_word.update(updated_at: Time.now)
          flash[:success] = "csv文件上传成功"
        rescue ActiveRecord::StatementInvalid
          flash[:danger] = "csv文件内容不正确"
        end
      end
    end
    redirect_to csvs_path
  end
end
