# WebAnno3 Docker Image

## Overview

A Dockerfile for the [WebAnno][webanno] collaborative language annotation web
platform, which basically just mirrors the [official installation guide][guide],
thus giving you an easy way to automatically set up WebAnno -- if you already
have [Docker][docker] installed that is.

Known to work on Arch Linux (up-to-date as of January 2016) with Docker version
1.12.5, build 7392c3b0ce. Let me know if you get this to work elsewhere!

## Usage

You need to have [Docker][docker] installed. Once you do, build the
`ucnk/webanno` Docker image with `build.sh` and run the container with `run.sh`.
Once initialization is done, you will land in `bash` (for debugging purposes,
plus it makes it easy to shut down the container by just `exit`ing the shell).

On your host computer, you can access WebAnno at <http://localhost:18080>.

[webanno]: https://webanno.github.io/webanno/
[guide]: https://webanno.github.io/webanno/releases/3.0.0/docs/admin-guide.html
[docker]: https://www.docker.com/
