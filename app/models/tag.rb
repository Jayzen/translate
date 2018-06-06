class Tag < ApplicationRecord
  belongs_to :user
  has_many :words
  validates :name, presence: { message: "单词分类不能为空" }, uniqueness: { scope: :user_id, message: "已经存在该单词分类"}
  default_scope { order("weight desc") }
end
