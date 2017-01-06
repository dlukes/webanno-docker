#!/usr/bin/env bash

root="$(realpath "$(dirname "$0")")"

docker run \
  -v "$root"/mysql/conf:/etc/mysql/conf.d \
  -v "$root"/mysql/data:/var/lib/mysql \
  -e MYSQL_USER=webanno -e MYSQL_DATABASE=webanno -e MYSQL_PASSWORD=t0t4llYSecreT \
  -p 18080:18080 \
  -ti ucnk/webanno
