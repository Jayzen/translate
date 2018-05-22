class Word < ApplicationRecord
  belongs_to :user
  belongs_to :tag, optional: true
  validates :name, presence: {message: "单词不能为空"}, uniqueness: {scope: :user_id, message: "已经存在该单词"}
end
