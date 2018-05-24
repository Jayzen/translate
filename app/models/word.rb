class Word < ApplicationRecord
  belongs_to :user
  belongs_to :tag, optional: true
  validates :name, presence: {message: "单词不能为空"}, uniqueness: {scope: :user_id, message: "已经存在该单词"}

  def self.translate(name)
    appKey = Rails.application.credentials.dig(:development, :youdao_appKey)
    secretKey = Rails.application.credentials.dig(:development, :youdao_secretKey)
    q, from, to, salt, myurl = name, 'EN', 'zh-CHS', Random.rand(10000).to_s, 'https://openapi.youdao.com/api'
    sign = Digest::MD5.hexdigest(appKey+q+salt+secretKey).upcase
    url = URI.escape(myurl+"?q="+q+"&from="+from+"&to="+to+"&appKey="+appKey+"&salt="+salt+"&sign="+sign)
    begin
      response = HTTParty.get(url)
    rescue SocketError
      response = "net_error"
    end
  end
end
