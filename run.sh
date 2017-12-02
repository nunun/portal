CWD=$(cd `dirname ${0}`; pwd)
COMMAND="${1:-"up"}"
ENVIRONMENT="${2:-"local"}"
cd "${CWD}"
set -e

up() { down; build; docker-compose up; }
down() { docker-compose down; }
build() { hugo; docker-compose build; }
publish() { build; docker-compose push; }
hugo() {
        # check ENVIRONMENT
        if [ "${COMMAND}" = "publish" -a "${ENVIRONMENT}" = "local" ]; then
                echo "could not publish 'local' environment."
                echo "please specify valid one like 'fu-n.net'."
                exit 1
        fi

        # check paths
        local project_path="${CWD}/nginx"
        local config_path="src/config.${ENVIRONMENT}.toml"
        if [ ! -f "${project_path}/${config_path}" ]; then
                echo "config file '${config_path}' not found?"
                exit 1
        fi

        # https://hub.docker.com/r/jojomi/hugo/
        [ "${OSTYPE}" = "cygwin" ] \
                && project_path="`cygpath -w ${project_path}`"
        docker run --rm \
                -v ${project_path}/src:/src \
                -v ${project_path}/html:/output \
                -v ${project_path}/${config_path}:/src/config.toml \
                jojomi/hugo
}

${COMMAND} # run!
