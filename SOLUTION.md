# `WDI JAZZ RECORDS` Lab
## DATA MODEL

```
rails g model Artist name:string
rails g model Album name:string edition:string is_crown:boolean is_core:boolean is_best_1001:boolean
rails g model RecordLabel name:string
```

## RELATIONSHIPS

### Migrations and database

```ruby
#
# rails g migration addArtistRefToAlbums artist:references
#
class AddArtistRefToAlbums < ActiveRecord::Migration
  def change
    add_reference :albums, :artist, index: true, foreign_key: true
  end
end
```

```ruby
#
# rails g migration addLabelRefToAlbums  record_label:references
#
class AddLabelRefToAlbums < ActiveRecord::Migration
  def change
    add_reference :albums, :record_label, index: true, foreign_key: true
  end
end
```

```
record_label_development=# \d
                List of relations
 Schema |         Name         |   Type   | Owner
--------+----------------------+----------+-------
 public | albums               | table    | f3r
 public | albums_id_seq        | sequence | f3r
 public | artists              | table    | f3r
 public | artists_id_seq       | sequence | f3r
 public | record_labels        | table    | f3r
 public | record_labels_id_seq | sequence | f3r
 public | schema_migrations    | table    | f3r
(7 rows)
```

```
record_label_development=# \d+ artists
Table "public.artists"
Column   |            Type             |                      Modifiers                       | Storage  | Stats target | Description
------------+-----------------------------+------------------------------------------------------+----------+--------------+-------------
id         | integer                     | not null default nextval('artists_id_seq'::regclass) | plain    |              |
name       | character varying           |                                                      | extended |              |
created_at | timestamp without time zone | not null                                             | plain    |              |
updated_at | timestamp without time zone | not null                                             | plain    |              |
Indexes:
"artists_pkey" PRIMARY KEY, btree (id)
Referenced by:
TABLE "albums" CONSTRAINT "fk_rails_124a79559a" FOREIGN KEY (artist_id) REFERENCES artists(id)
```

```
record_label_development=# \d+ albums
Table "public.albums"
Column      |            Type             |                      Modifiers                      | Storage  | Stats target | Description
-----------------+-----------------------------+-----------------------------------------------------+----------+--------------+-------------
id              | integer                     | not null default nextval('albums_id_seq'::regclass) | plain    |              |
name            | character varying           |                                                     | extended |              |
edition         | character varying           |                                                     | extended |              |
is_crown        | boolean                     |                                                     | plain    |              |
is_core         | boolean                     |                                                     | plain    |              |
is_best_1001    | boolean                     |                                                     | plain    |              |
created_at      | timestamp without time zone | not null                                            | plain    |              |
updated_at      | timestamp without time zone | not null                                            | plain    |              |
artist_id       | integer                     |                                                     | plain    |              |
record_label_id | integer                     |                                                     | plain    |              |
Indexes:
"albums_pkey" PRIMARY KEY, btree (id)
"index_albums_on_artist_id" btree (artist_id)
"index_albums_on_record_label_id" btree (record_label_id)
Foreign-key constraints:
"fk_rails_124a79559a" FOREIGN KEY (artist_id) REFERENCES artists(id)
"fk_rails_4bcd93cb5c" FOREIGN KEY (record_label_id) REFERENCES record_labels(id)
```

```
record_label_development=# \d+ record_labels
Table "public.record_labels"
Column   |            Type             |                         Modifiers                          | Storage  | Stats target | Description
------------+-----------------------------+------------------------------------------------------------+----------+--------------+-------------
id         | integer                     | not null default nextval('record_labels_id_seq'::regclass) | plain    |              |
name       | character varying           |                                                            | extended |              |
created_at | timestamp without time zone | not null                                                   | plain    |              |
updated_at | timestamp without time zone | not null                                                   | plain    |              |
Indexes:
"record_labels_pkey" PRIMARY KEY, btree (id)
Referenced by:
TABLE "albums" CONSTRAINT "fk_rails_4bcd93cb5c" FOREIGN KEY (record_label_id) REFERENCES record_labels(id)
```

### Models

```ruby
class Album < ActiveRecord::Base
  belongs_to :artist
  belongs_to :record_label
end
```

```ruby
class Artist < ActiveRecord::Base
  has_many :albums
  has_many :record_labels, through: :albums
end
```

```ruby
class RecordLabel < ActiveRecord::Base
  has_many :albums
  has_many :artists, through: :albums
end
```

## IMPORTING DATA

```ruby
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
```
