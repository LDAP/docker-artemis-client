# Artemis Client Docker

For usage refer to [LDAP/docker-compose-artemis](https://github.com/LDAP/docker-compose-artemis).

Enabling CORS may be necessary on server side. See the documentation [here](https://www.jhipster.tech/separating-front-end-and-api/).

## Environment variables

|Variable                  |Description                                                           |
|--------------------------|----------------------------------------------------------------------|
|API_REDIRECT_URL          |Redirect URL for API calls, without trailing slash __mandatory__!     |
|SERVER_NAME               |NGINX server_name for artemis. __mandatory__!                         |

## Mount points

|Mount                                                           |Description                                    |
|----------------------------------------------------------------|-----------------------------------------------|
|`/etc/nginx/conf.d/`                                            |generated configs, used to overwrite configs   |
|`/var/log/nginx`                                                |log directory                                  |
|`/usr/share/nginx/html/public/images/logo.png`                  |set own logo. _recommended_                    |
|`/usr/share/nginx/html/favicon.ico`                             |set own favicon. _recommended_                 |
|`/usr/share/nginx/html/public/content/privacy_statement.html`   |set own privacy statement. _recommended_       |
|`/var/log/nginx/`                                               |nginx logs directory                           |

## Ports
This container exposes port 80. Run the container with `-P` to publish all exposed ports to the host interfaces.
You can overwrite the default with `-p hostPort:80`.

## Development

### Build arguments

|Argument                  |Description                                    |
|--------------------------|-----------------------------------------------|
|ARTEMIS_VERSION           |Git tag or branch name, default: develop       |