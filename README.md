## Server

### create db

```
CREATE TABLE links (
  _id serial primary key,
  title text,
  url text,
  rating integer default 0,
  create_date timestamp default current_timestamp
);

CREATE TABLE comments (
  _id serial primary key,
  link_id integer references links(_id),
  body text,
  create_date timestamp default current_timestamp,
  rating integer default 0
);
```

### run

```
  pgrest --db ### --websocket
```

## Client

fix host if you're not running on localhost

open index.html
