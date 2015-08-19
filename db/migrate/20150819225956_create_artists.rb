#
# rails g model Artist name:string
#
class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
