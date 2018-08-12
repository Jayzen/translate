class Category < ApplicationRecord
  belongs_to :user
  has_many :words

  validates :name, presence: { message: "单词分类名称不能为空"}, uniqueness: { scope: :user_id, message: "已经存在该单词分类"}
  default_scope { order("weight desc") }
  
  #def record
  #  @records ||= Category.all.each_with_index.map do |object, index| 
  #    @records = Hash.new
  #    @records.update(object => index)
  #    @records
  #  end
  #  if @records.keys.include?(self)
  #    return @records[self]+1
  #  end
  #end
end
