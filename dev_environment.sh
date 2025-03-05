#!/bin/bash

# Ensure the script fails on any error
set -e

# Default tag suffix
TAG_SUFFIX="latest-devel"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -p|--prod)
      TAG_SUFFIX="prod-devel"
      shift
      ;;
    *)
      shift
      ;;
  esac
done

# Check if we're in a git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: Not in a git repository"
    exit 1
fi

# Get the full repository path from git remote URL (excluding .git and the domain)
REPO_PATH=$(git config --get remote.origin.url | sed -E 's#^(https?://gitlab\.com/|git@gitlab\.com:)(.*)\.git$#\2#')
REPO_NAME=$(basename ${REPO_PATH})

# Convert repository path to lowercase for Docker compatibility
REPO_PATH_LOWERCASE=$(echo ${REPO_PATH} | tr '[:upper:]' '[:lower:]')

# Get the git root directory
GIT_ROOT=$(git rev-parse --show-toplevel)

# Check if docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Docker is not running. Please start Docker first."
    exit 1
fi

# Get the GitLab registry URL from the environment or use a default
GITLAB_REGISTRY=${CI_REGISTRY:-"registry.gitlab.com"}
# Use the repository's own image with full path - ensure lowercase for Docker
IMAGE_NAME="${REPO_PATH_LOWERCASE}:${TAG_SUFFIX}"
FULL_IMAGE_PATH="${GITLAB_REGISTRY}/${IMAGE_NAME}"

echo "Detected repository path: ${REPO_PATH}"
echo "Using image: ${FULL_IMAGE_PATH}"

# Check for newer image version
echo "Checking for newer image version..."
docker pull ${FULL_IMAGE_PATH}

# Check if running on macOS
if [[ "$(uname)" == "Darwin" ]]; then
    # On macOS, we'll create the directory inside the container
    echo "Running on macOS - will create /gem_test inside container"
    MOUNT_GEM_TEST=""
    STARTUP_CMD="mkdir -p /gem_test && bash -l"
else
    # On Linux, try to mount external directory
    if [ ! -d "/gem_test" ]; then
        echo "Creating /gem_test directory..."
        sudo mkdir -p /gem_test
    fi
    MOUNT_GEM_TEST="-v /gem_test:/gem_test"
    STARTUP_CMD="bash -l"
fi

# Run the container with all necessary mounts and environment
docker run -it --rm \
    ${MOUNT_GEM_TEST} \
    -v ${GIT_ROOT}:/repo \
    -v ${HOME}/.gitconfig:/root/.gitconfig \
    -v ${HOME}/.git-credentials:/root/.git-credentials \
    -v ${HOME}/.ssh:/root/.ssh \
    -v ${HOME}/.docker:/root/.docker \
    -w /repo \
    ${FULL_IMAGE_PATH} \
    bash -c "${STARTUP_CMD}"