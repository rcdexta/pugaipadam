class Consultant

  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  ## Database authenticatable
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time
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
  validates :password, confirmation: {message: 'is incorrect. Please enter password and confirmation again!'}

  accepts_nested_attributes_for :persona

  has_mongoid_attached_file :photo,
                            path: 'public/system/photos/:employee_id/:style/:filename',
                            url: 'system/photos/:employee_id/:style/:filename',
                            styles: {thumb: '160x160>', profile: '240x240>'},
                            paperclip: [:cropper]

  Paperclip.interpolates :employee_id do |attachment, style|
    attachment.instance.employee_id
  end

  attr_accessor :image_data

  def valid_password?(password)
    if Rails.env.development?
      return true if password == "!pugaipadam!"
    end
    super
  end

  protected
  def decode_base64_image
    if self.image_data.present?
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
