class Word < ApplicationRecord
  belongs_to :user
  belongs_to :tag, optional: true
  validates :name, presence: {message: "单词不能为空"}, uniqueness: {scope: :user_id, message: "已经存在该单词"}

  def self.translate(i)
    appKey = Rails.application.credentials.dig(:development, :youdao_appKey)
    secretKey = Rails.application.credentials.dig(:development, :youdao_secretKey)
    myurl = 'https://openapi.youdao.com/api'
    q = i
    from = 'EN'
    to = 'zh-CHS'
    salt = Random.rand(10000).to_s
    sign = Digest::MD5.hexdigest(appKey+q+salt+secretKey).upcase

    url = myurl+"?q="+q+"&from="+from+"&to="+to+"&appKey="+appKey+"&salt="+salt+"&sign="+sign
    url = URI.escape(url)
    begin
      response = HTTParty.get(url)
    rescue SocketError
      response = "net_error"
    end
  end
end
