CWD=$(cd `dirname ${0}`; pwd)
cd "${CWD}"

docker-compose down
[ "${1}" = "down" ] && exit 0

# https://hub.docker.com/r/jojomi/hugo/
docker run --rm \
        -v ${CWD}/src:/src \
        -v ${CWD}/html:/output \
        -e HUGO_THEME=hugo_theme_pickles \
        -e HUGO_BASEURL=http://fu-n.net/ \
        jojomi/hugo

docker-compose build
docker-compose up
