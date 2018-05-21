class Tag < ApplicationRecord
  belongs_to :user
  has_many :words
  validates :name, presence: { message: "单词分类不能为空" }
end
