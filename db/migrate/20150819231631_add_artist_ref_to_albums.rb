#
# rails g migration addArtistRefToAlbums artist:references
#
class AddArtistRefToAlbums < ActiveRecord::Migration
  def change
    # ADDS A FOREIGN KEY TO ALBUMS IN POSTGRES
    add_reference :albums, :artist, index: true, foreign_key: true

    # DOES NOT ADD A FOREIGN KEY TO ALBUMS IN POSTGRES
    # add_column :albums, :artist_id, :integer
  end
end
