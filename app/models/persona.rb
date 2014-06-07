class Persona
  include Mongoid::Document

  field :twitter, type: String
  field :github, type: String
  field :stackoverflow, type: String
  field :blog, type: String
  field :good_reads, type: String

  def present?
    twitter.present? or github.present? or stackoverflow.present? or blog.present? or good_reads.present?
  end

  belongs_to :consultant
end