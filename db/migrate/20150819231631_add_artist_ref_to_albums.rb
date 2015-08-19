#
# rails g migration addArtistRefToAlbums artist:references
#
class AddArtistRefToAlbums < ActiveRecord::Migration
  def change
    add_reference :albums, :artist, index: true, foreign_key: true
  end
end
