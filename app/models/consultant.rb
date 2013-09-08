class Consultant

  include Mongoid::Document
  include Mongoid::Paperclip

  field :jigsaw_id, type: Integer
  field :employee_id, type: Integer
  field :name, type: String
  field :nickname, type: String
  field :mobile, type: String
  field :email, type: String
  field :role, type: String
  field :grade, type: String
  field :experience, type: Float
  field :tw_experience, type: Float
  field :active, type: Boolean

  default_scope where(active: true)

  belongs_to :project
  has_one :persona
  has_many :activities

  accepts_nested_attributes_for :persona

  has_mongoid_attached_file :photo,
                            path: "public/system/photos/:employee_id/:style/:filename",
                            url: "system/photos/:employee_id/:style/:filename"

  Paperclip.interpolates :employee_id do |attachment, style|
    attachment.instance.employee_id
  end
end
