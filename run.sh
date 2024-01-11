#!/usr/bin/env bash
ENABLE_LOGS=0
usage() {
 echo "Usage: $0 [OPTIONS]"
 echo "Options:"
 echo " -h, --help      Display this help message"
 echo " -b, --verbose   build image"
 echo " -l, --verbose   get container logs"
}
function prerequisite(){
  echo "Checking if Docker engine started!"
  docker ps > /dev/null 2>1 || sudo service docker start
  echo "Docker engine is running!"
}

function build(){
  docker rmi $(docker images -q --filter "dangling=true") || echo "nothing to clean in images"
  docker tag appdemo previous-version
  docker build . -t appdemo
  image_sha=$(docker images -q appdemo)
  echo "Image has built! sha: $image_sha"
}

function run() {
    echo "cleanup!"
    docker rm -f $(docker ps -a -q) || echo "nothing to cleanup"
    docker run -d --name myapp1 -p 5000:5000 appdemo || exit "Can't start" 1
    echo "Application Started on port 5000!"
}

function logs() {
    docker logs myapp1 -f
}

handle_options() {
  while [ $# -gt 0 ]; do
    case $1 in
      -h | --help)
        usage
        exit 0
        ;;
      -b | --build)
        build
        ;;
      -l | --logs)
        ENABLE_LOGS=1
        ;;

      *)
        echo "Invalid option: $1" >&2
        usage
        exit 1
        ;;
    esac
    shift
  done
}

# Main script execution
handle_options "$@"
run
if [[ "$ENABLE_LOGS" -gt 0 ]]; then
  logs
fi

trap "echo The script is terminated; exit" SIGINT