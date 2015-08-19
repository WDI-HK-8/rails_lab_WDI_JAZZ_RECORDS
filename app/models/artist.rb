class Artist < ActiveRecord::Base
  has_many :albums
  has_many :record_labels, through: :albums
end
