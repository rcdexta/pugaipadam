class Activity
  include Mongoid::Document

  field :at, type: DateTime
  field :type, type: String
  field :content, type: String

  scope :recent, order_by(:at => :desc).limit(15)

  belongs_to :consultant
end