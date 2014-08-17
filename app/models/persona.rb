class Persona
  include Mongoid::Document

  field :twitter, type: String
  field :github, type: String
  field :stackoverflow, type: String
  field :blog, type: String
  field :good_reads, type: String

  def present?
    [twitter, github, stackoverflow, blog, good_reads].any? { |p| p.present? }
  end

  belongs_to :consultant
end