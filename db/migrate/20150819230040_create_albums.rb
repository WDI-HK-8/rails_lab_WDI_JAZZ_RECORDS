#
# rails g model Album name:string edition:string is_crown:boolean is_core:boolean is_best_1001:boolean
#
class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :name
      t.string :edition
      t.boolean :is_crown
      t.boolean :is_core
      t.boolean :is_best_1001

      t.timestamps null: false
    end
  end
end
