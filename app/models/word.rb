class Word < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :category, optional: true
  belongs_to :tag, optional: true
  validates :name, presence: {message: "单词不能为空"}, uniqueness: {scope: :user_id, message: "已经存在该单词"}

  class << self
    def translate(name)
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

    def import(file)
      words = []
      CSV.foreach(file.path, headers: true) do |row|
        word_hash = row.to_hash
        words << word_hash
      end
      words
    end

    def to_csv(fields = column_names, options = {})
      CSV.generate(options) do |csv|
        csv << fields
        all.each do |word|
          csv << word.attributes.values_at(*fields)
        end
      end
    end
  end
end
