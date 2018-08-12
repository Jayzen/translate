class Task < ApplicationRecord
  belongs_to :user
  validates :name, presence: { message: "名称不能为空"}, uniqueness: { scope: :user_id, message: "已经存在该单词计划"}
end
