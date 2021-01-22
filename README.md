# Artemis Client Docker

## Environment variables

|Variable                  |Description                                                           |
|--------------------------|----------------------------------------------------------------------|
|API_REDIRECT_URL          |Redirect URL for API calls, without trailing slash __mandatory__!     |
|SERVER_NAME               |NGINX server_name for artemis. __mandatory__!                         |

## Mount points

|Mount                     |Description                                    |
|--------------------------|-----------------------------------------------|
|`/etc/nginx/conf.d/`      |generated configs, use to overwrite configs    |
|`/var/log/nginx`          |log directory                                  |

## Ports
This container exposes port 80. Run the container with `-P` to publish all exposed ports to the host interfaces.
You can overwrite the default with `-p hostPort:80`.

## Development

### Build arguments

|Argument                  |Description                                    |
|--------------------------|-----------------------------------------------|
|ARTEMIS_VERSION           |Git tag or branch name                         |