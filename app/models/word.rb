class Word < ApplicationRecord
  belongs_to :user
  belongs_to :tag, optional: true
  validates :name, uniqueness: {message: "已经存在该单词"}
end
