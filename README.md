## Server

### Download latest pgrest-websocket

```
git clone https://github.com/pgrest/pgrest-websocket
cd pgrest-websocket
npm i
npm run prepublish
```

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
  ./bin/cmd.js --db YOUR_DB_NAME --websocket
```

## Client

fix host in index.ls and compile it with lsc if you're not running on localhost

open index.html with browser
