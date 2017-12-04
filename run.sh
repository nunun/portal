CWD=$(cd `dirname ${0}`; pwd)
TASK="${1:-"up"}"
ENVIRONMENT="${2:-"local"}"
PUBLISH_ENVIRONMENT="${2:-"fu-n.net"}"
set -e
cd "${CWD}"

task_up() { task_down; task_build; docker-compose up; }
task_down() { docker-compose down; }
task_build() { task_hugo; ENVIRONMENT="${ENVIRONMENT}" docker-compose build; }
task_hugo() {
        for v in "portal" "www"; do
                local config_toml="config.${ENVIRONMENT}.toml"
                echo "build hugo site '${v}' with config '${config_toml}' ..."

                # check paths
                local project_path="${CWD}/nginx"
                local config_path="src/${v}/${config_toml}"
                if [ ! -f "${project_path}/${config_path}" ]; then
                        echo "config file '${config_path}' not found?"
                        exit 1
                fi

                # https://hub.docker.com/r/jojomi/hugo/
                [ "${OSTYPE}" = "cygwin" ] \
                        && project_path="`cygpath -w ${project_path}`"
                docker run --rm \
                        -v ${project_path}/src/${v}:/src \
                        -v ${project_path}/html/${v}:/output \
                        -v ${project_path}/${config_path}:/src/config.toml \
                        jojomi/hugo
        done
}
task_publish() {
        ENVIRONMENT="${PUBLISH_ENVIRONMENT}"
        local publish_destination="${ENVIRONMENT}:5000/portal/compose"
        echo "publish compose image '${publish_destination}' ..."
        task_build
        curl -sSL https://raw.githubusercontent.com/nunun/swarm-builder/master/push.sh \
                | sh -s docker-compose.* ${publish_destination}
}
task_${TASK}
