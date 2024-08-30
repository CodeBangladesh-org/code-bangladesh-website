#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Define the Docker image name for Jekyll
DOCKER_IMAGE_NAME="jekyll_site_builder"

# Function to build the Docker image
build_docker_image() {
    echo "Building Docker image for Jekyll..."
    docker build -t $DOCKER_IMAGE_NAME .
}

# Function to run the Docker container for building the Jekyll site
run_build_container() {
    echo "Building Jekyll site..."
    docker run --rm -it -v "$PWD:/srv/jekyll" -w /srv/jekyll $DOCKER_IMAGE_NAME "$@"
}

# Main case statement to handle different script arguments
case "$1" in
    'prod-build')
        build_docker_image
        run_build_container build -e JEKYLL_ENV=prod
        ;;
    'build')
        build_docker_image
        run_build_container build
        ;;
    'serve')
        echo "Serving Jekyll site..."
        docker run --rm -it -v "$PWD:/srv/jekyll" -p 4000:4000 $DOCKER_IMAGE_NAME serve
        ;;
    *)
        echo "Usage: $0 {prod-build|build|serve}"
        exit 1
        ;;
esac
