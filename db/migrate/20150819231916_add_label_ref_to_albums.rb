#
# rails g migration addLabelRefToAlbums  record_label:references
#
class AddLabelRefToAlbums < ActiveRecord::Migration
  def change
    add_reference :albums, :record_label, index: true, foreign_key: true
  end
end
