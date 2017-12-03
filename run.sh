CWD=$(cd `dirname ${0}`; pwd)
TASK="${1:-"up"}"
ENVIRONMENT="${2:-"local"}"
set -e
cd "${CWD}"

task_up() { task_down; task_build; docker-compose up; }
task_down() { docker-compose down; }
task_build() { task_hugo; docker-compose build; }
task_hugo() {
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
task_publish() {
        if [ "${ENVIRONMENT}" = "local" ]; then
                echo "could not publish to environment name 'local'."
                echo "please specify remote environment name like 'fu-n.net'."
                exit 1
        fi
        task_build
        curl -sSL https://raw.githubusercontent.com/nunun/swarm-builder/master/push.sh \
                | sh -s . ${ENVIRONMENT}:5000/portal/compose
        echo "done."
}
task_${TASK}
