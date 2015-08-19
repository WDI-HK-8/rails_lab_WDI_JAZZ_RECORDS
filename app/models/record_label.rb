class RecordLabel < ActiveRecord::Base
  has_many :albums
  has_many :artists, through: :albums
end
