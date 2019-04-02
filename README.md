# Alpine Varnish Image

![https://www.augustash.com](http://augustash.s3.amazonaws.com/logos/ash-inline-color-500.png)

**This base container is not currently aimed at public consumption. It exists as a starting point for August Ash containers.**

## Versions

- `3.0.0`, `latest` [(Dockerfile)](https://github.com/augustash/docker-alpine-varnish/blob/3.0.0/Dockerfile)
- `2.0.0` [(Dockerfile)](https://github.com/augustash/docker-alpine-varnish/blob/2.0.0/Dockerfile)
- `1.0.2` [(Dockerfile)](https://github.com/augustash/docker-alpine-varnish/blob/1.0.2/Dockerfile)
- `1.0.1` [(Dockerfile)](https://github.com/augustash/docker-alpine-varnish/blob/1.0.1/Dockerfile)
- `1.0.0` [(Dockerfile)](https://github.com/augustash/docker-alpine-varnish/blob/1.0.0/Dockerfile)

[See VERSIONS.md for image contents.](https://github.com/augustash/docker-alpine-varnish/blob/master/VERSIONS.md)

## Usage

Launch an application container and Varnish container that serves content proxied to the `app` container:

```bash
docker run --rm \
    --name app \
    --net <NETWORK NAME> \
    -v $(pwd):/src \
    augustash/alpine-nginx

docker run --rm \
    -p 8080:80 \
    --link <APP CONTAINER>:app \
    --net <NETWORK NAME> \
    -e VARNISH_BACKEND_HOST=app \
    -v $(pwd)/varnish.template:/etc/varnish/default.vcl \
    augustash/alpine-varnish
```

### Varnish Configuration

The image is prepared in a way to make it relatively easy to customize Varnish. Custom configuration should be mounted as `/etc/varnish/default.vcl`.

```bash
docker run --rm \
    -v $(pwd)/varnish.template:/etc/varnish/default.vcl \
    augustash/alpine-varnish
```

### User/Group Identifiers

To help avoid nasty permissions errors, the container allows you to specify your own `PUID` and `PGID`. This can be a user you've created or even root (not recommended).

### Environment Variables

The following variables can be set and will change how the container behaves. You can use the `-e` flag, an environment file, or your Docker Compose file to set your preferred values. The default values are shown:

- `PUID`=501
- `PGID`=1000
- `VARNISH_VCL_CONF`=/etc/varnish/default.vcl
- `VARNISH_SECRET_FILE`=/etc/varnish/secret
- `VARNISH_LISTEN_PORT`=80
- `VARNISH_ADMIN_LISTEN_PORT`=6082
- `VARNISH_BACKEND_PORT`=80
- `VARNISH_BACKEND_HOST`=web
- `VARNISH_CACHE_SIZE`=64M
- `VARNISHD_PARAMS`=-p default_ttl=3600 -p default_grace=3600

## Logging Output

The output of `varnishncsa` is piped to the standard output of the container, allowing the docker daemon to read it and direct that data to anywhere you wish.

The default format, set via the environment variable `VARNISH_LOG_FORMAT`, that is passed to `varnishncsa`:

```bash
%{x-forwarded-for}i - %u %t "%r" %s %b %T "%{Referer}i" "%{User-agent}i" [%{Varnish:handling}x]
```

## Inspiration

- [fballiano](https://github.com/fballiano/)
- [joshporter](https://github.com/joshporter)
- [meanbee](https://github.com/meanbee/)
