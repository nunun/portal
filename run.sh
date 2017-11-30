CWD=$(cd `dirname ${0}`; pwd)
FQDN="${1:-"fu-n.net"}"
COMMAND="${2:-""}"
cd "${CWD}"

docker-compose down
[ "${COMMAND}" = "down" ] && exit 0

# https://hub.docker.com/r/jojomi/hugo/
COMPOSE_PATH="${CWD}"
[ "${OSTYPE}" = "cygwin" ] && COMPOSE_PATH="`cygpath -w ${CWD}`"
docker run --rm \
        -v ${COMPOSE_PATH}/src:/src \
        -v ${COMPOSE_PATH}/html:/output \
        -v ${COMPOSE_PATH}/src/config.${FQDN}.toml:/src/config.toml \
        -e HUGO_THEME=slate \
        -e HUGO_BASEURL=http://${FQDN}/ \
        jojomi/hugo
docker-compose build
[ "${COMMAND}" = "build" ] && exit 0

docker-compose up
