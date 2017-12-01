CWD=$(cd `dirname ${0}`; pwd)
COMMAND="${1:-"up"}"
ENVIRONMENT="${2:-"local"}"
cd "${CWD}"
set -e

up() { down; build; docker-compose up; }
down() { docker-compose down; }
build() { hugo; docker-compose build; }
push() { build; docker-compose push; }
hugo() {
        # https://hub.docker.com/r/jojomi/hugo/
        local project_path="${CWD}"
        local config_path="${project_path}/src/config.${ENVIRONMENT}.toml"
        [ "${OSTYPE}" = "cygwin" ] && project_path="`cygpath -w ${CWD}`"
        [ ! -f "${config_path}" ] && echo "'${config_path}' not found?" && exit 1
        docker run --rm \
                -v ${project_path}/src:/src \
                -v ${project_path}/html:/output \
                -v ${project_path}/src/config.${ENVIRONMENT}.toml:/src/config.toml \
                jojomi/hugo
}

${COMMAND}
