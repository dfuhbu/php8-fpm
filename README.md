https://easyengine.io/tutorials/php/directly-connect-php-fpm/

docker build --no-cache -t registry.gitlab.com/wumvi/fpm8:0.0.10 .

docker push registry.gitlab.com/wumvi/fpm.common:0.0.9

```bash
php make.php > DockerfileAutoBuild
docker build -t dfuhbu/php8-fpm:0.0.1 -f DockerfileAutoBuild .
docker push dfuhbu/php8-fpm:0.0.1
```

### test

```bash
docker run -ti --rm \
    -v bridge:/bridge/ \
    -e PM_LISTEN=/bridge/service.test.sock \
    --name fpm-test \
    dfuhbu/php8-fpm:0.0.1
```