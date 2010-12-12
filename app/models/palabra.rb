class Palabra < ActiveRecord::Base
  belongs_to :verb
  belongs_to :tiempo
  belongs_to :forma
end
