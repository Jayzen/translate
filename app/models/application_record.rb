class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  module Status
    On = true
    Off = false
  end

  scope :zh, -> { where(language: "zh") }
  scope :en, -> { where(language: "en") }
  scope :zh_order, -> { zh.where(status: true).order("weight desc") }
  scope :en_order, -> { en.where(status: true).order("weight desc") }
  scope :zh_status, -> { zh.where(status: true) }
  scope :en_status, -> { en.where(status: true) }
end
