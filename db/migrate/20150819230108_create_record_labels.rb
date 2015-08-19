#
# rails g model RecordLabel name:string
#
class CreateRecordLabels < ActiveRecord::Migration
  def change
    create_table :record_labels do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
