class CsvsController < ApplicationController
  def index
    @words = current_user.words
    respond_to do |format|
      format.html
      format.csv { send_data @words.to_csv(['name', 'chinese', 'uk', 'us']) }
    end 
  end

  def import
    if !params[:file].nil? && params[:file].path =~ /.+\.csv$/
      words = Word.import(params[:file])
      words.each do |word|
        begin
          new_word = current_user.words.find_or_create_by(word)
          new_word.update(updated_at: Time.now)
        rescue ActiveRecord::StatementInvalid
          flash[:danger] = "csv文件内容不正确"
          redirect_to csvs_path and return 
        end
      end
      flash[:success] = "csv文件导入成功"
    else
      flash[:danger] = "csv文件格式不正确"
    end
    redirect_to csvs_path
  end
end
