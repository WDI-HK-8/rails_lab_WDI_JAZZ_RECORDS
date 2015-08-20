# Data imported from:
# http://people.ucalgary.ca/~ghfick/jazz.html
# - http://people.ucalgary.ca/~ghfick/four_crown_core_thousand_beta2.csv

# Info: The current list available for download has been updated to include all CDs that have been given 4 stars in any edition of the guide up to and including the tenth edition. The current list contains 3615 entries and many of the entries refer to multi-disc sets. The list contains a column noting the edition in which an entry was first given a four star rating. Three further columns identify if an entry is crown, core or a part of the best 1001.


# "musician",          "album",           "label", "edition", "crown", "core", "best_1001"
# "Armstrong, Louis" , "Young LA 30-33" , "RCA",   3,          "No" ,  "No" ,  "No"

require 'csv'

CSV.foreach("db/seeds.csv", :headers => true) do |row|
  data = {
      musician:  row[0].strip,
      album:     row[1].strip,
      label:     row[2].strip,
      edition:   row[3].to_i,
      crown:     (row[4] == "Yes"),
      core:      (row[5] == "Yes"),
      best_1001: (row[6] == "Yes")
  }

  # http://apidock.com/rails/ActiveRecord/Relation/first_or_create
  myArtist = Artist.where(name: data[:musician]).first_or_create do |artist|
    artist.name = data[:musician]
  end

  myLabel = RecordLabel.where(name: data[:label]).first_or_create do |record_label|
    record_label.name = data[:label]
  end

  Album.where(name: data[:album]).first_or_create do |album|
    # Attributes of album
    album.name         = data[:album]
    album.edition      = data[:edition]
    album.is_crown     = data[:crown]
    album.is_core      = data[:core]
    album.is_best_1001 = data[:best_1001]

    # Relationships of album
    album.artist       = myArtist
    album.record_label = myLabel
  end
end
