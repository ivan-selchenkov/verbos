class Verb < ActiveRecord::Base
  has_many :irregulars
  has_many :palabras
end
