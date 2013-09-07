class Persona
  include Mongoid::Document

  field :twitter, type: String
  field :github, type: String
  field :stackoverflow, type: String
  field :blog, type: String
  field :good_reads, type: String

  belongs_to :consultant
end