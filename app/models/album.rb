class Album < ActiveRecord::Base
  belongs_to :artist
  belongs_to :record_label
end
