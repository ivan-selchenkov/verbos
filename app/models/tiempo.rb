class Tiempo < ActiveRecord::Base
  belongs_to :modo
  has_many :irregulars
end
