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

  before_save :decode_base64_image

  default_scope where(active: true)

  belongs_to :project
  has_one :persona
  has_many :activities

  validates :name, presence: {message: 'is a required field'}

  accepts_nested_attributes_for :persona

  has_mongoid_attached_file :photo,
                            path: "public/system/photos/:employee_id/:style/:filename",
                            url: "system/photos/:employee_id/:style/:filename",
                            styles: {thumb: "160x160>"},
                            paperclip: [:cropper]

  Paperclip.interpolates :employee_id do |attachment, style|
    attachment.instance.employee_id
  end

  attr_accessor :image_data

  protected
  def decode_base64_image
    image_data = self.attributes.delete('image_data')
    if image_data.present?
      decoded_data = Base64.decode64(image_data.split(',').last)

      data = StringIO.new(decoded_data)

      data.class_eval do
        attr_accessor :content_type, :original_filename
      end

      data.content_type = 'image/jpeg'
      data.original_filename = "#{employee_id}.jpg"

      self.photo = data
    end
  end


end
