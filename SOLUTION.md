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
