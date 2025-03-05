#!/bin/bash

# Ensure script fails on any error
set -e

# Default repository path
REPO_PATH="rpm-repo/1.0"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -p|--prod)
      REPO_PATH="prod/1.0"
      shift
      ;;
    *)
      shift
      ;;
  esac
done

# Get package name from spec file or git as fallback
SPEC_FILE=$(ls *.spec)
if [ -z "$SPEC_FILE" ]; then
    echo "No .spec file found in repository"
    exit 1
fi

# Try to get package name from spec file first (for pipeline)
# First check if there's a %define name statement
PACKAGE_NAME=$(grep "^%define name" $SPEC_FILE | awk '{print $3}')
# If not found, try the Name: field
if [ -z "$PACKAGE_NAME" ]; then
    PACKAGE_NAME=$(grep "^Name:" $SPEC_FILE | awk '{print $2}' | sed 's/%{name}/gis_mk/')
fi

# If package name is empty, try git (for local builds)
if [ -z "$PACKAGE_NAME" ]; then
    PACKAGE_NAME=$(basename -s .git $(git config --get remote.origin.url))
    if [ -z "$PACKAGE_NAME" ]; then
        echo "Could not determine package name from spec file or git"
        exit 1
    fi
fi

# Get git hash for the release
GIT_HASH=$(git rev-parse --short HEAD 2>/dev/null || echo "nogit")
echo "Git hash: $GIT_HASH"

echo "Building package: $PACKAGE_NAME"
echo "Using repository path: $REPO_PATH"

# Pull the container
echo "Pulling Rocky 8 base image..."
docker pull rockylinux:8

# Run the build in container
echo "Running build in container..."
docker run --rm -v $(pwd):/work -w /work \
    rockylinux:8 \
    /bin/bash -c 'set -ex && \
        # Configure GitLab repository first
        echo "[gitlab-rpm-repo]
name=GitLab RPM Repository
baseurl=https://oauth2:***REMOVED***@gitlab.com/api/v4/projects/66226575/packages/generic/'$REPO_PATH'/
enabled=1
gpgcheck=0" > /etc/yum.repos.d/gitlab-rpm-repo.repo && \
        
        # Enable PowerTools and EPEL repositories
        dnf install -y epel-release && \
        dnf install -y dnf-plugins-core && \
        dnf config-manager --set-enabled powertools && \
        dnf makecache --refresh && \

        # Install gemini-ade package
        dnf install -y gemini-ade && \
        
        # Now we can source the ADE environment
        source /etc/profile.d/ade.sh && \
        
        # Install minimal build requirements
        dnf install -y rpm-build make gcc gcc-c++ re2c && \
        
        # Find the spec file
        SPEC_FILE=$(ls *.spec) &&
        echo "Found spec file: $SPEC_FILE" &&
        if [ -z "$SPEC_FILE" ]; then
            echo "No .spec file found in repository" &&
            exit 1
        fi &&

        # Create a temporary spec file with modified Release
        TMP_SPEC="/tmp/${SPEC_FILE}.tmp" &&
        cp $SPEC_FILE $TMP_SPEC &&
        chmod 644 $TMP_SPEC &&
        
        # Extract current Release from spec file
        RELEASE=$(grep "^Release:" $TMP_SPEC | awk "{print \$2}") &&
        if [ -z "$RELEASE" ]; then
            # If no Release field, add one
            echo "No Release field found, adding one with git hash" &&
            sed -i "/^Version:/a Release: 1.git'$GIT_HASH'%{?dist}" $TMP_SPEC
        else
            # If Release field exists, append git hash to it
            echo "Modifying Release field to include git hash" &&
            sed -i "s/^Release: .*/Release: 1.git'$GIT_HASH'%{?dist}/" $TMP_SPEC
        fi &&
        
        # Show the modified spec file
        echo "Modified spec file:" &&
        cat $TMP_SPEC &&

        # Install build dependencies from spec file
        echo "Checking if spec file exists: $TMP_SPEC" &&
        ls -la $TMP_SPEC &&
        echo "Contents of spec file:" &&
        cat $TMP_SPEC &&
        echo "Enabling source repositories..." &&
        dnf config-manager --set-enabled appstream-source baseos-source powertools-source epel-source &&
        echo "Installing build dependencies..." &&
        (dnf builddep -y $TMP_SPEC || {
            echo "Failed to install build dependencies with dnf builddep. Trying manual installation..."
            # Extract BuildRequires from spec file
            BUILD_DEPS=$(grep "^BuildRequires:" $TMP_SPEC | sed 's/BuildRequires://g' | tr -d '\n')
            echo "Attempting to install: $BUILD_DEPS"
            dnf install -y $BUILD_DEPS || true
        }) &&

        # Extract version from spec file
        PACKAGE_VERSION=$(grep "^Version:" $TMP_SPEC | awk "{print \$2}") &&
        echo "Package version: $PACKAGE_VERSION" &&

        # Create source directory and tarball with correct structure
        mkdir -p /root/rpmbuild/SOURCES &&
        dir_name="'$PACKAGE_NAME'-${PACKAGE_VERSION}" &&
        echo "Creating tarball with name: $dir_name" &&
        tar --transform "s,^,${dir_name}/," -czf /root/rpmbuild/SOURCES/${dir_name}.tar.gz . &&
        ls -l /root/rpmbuild/SOURCES/ &&
        
        make &&
        rpmbuild -ba $TMP_SPEC &&
        
        # Show what was built
        ls -l /root/rpmbuild/RPMS/x86_64/ &&
        
        # Copy RPMs to mounted volume
        mkdir -p /work/rpms &&
        cp /root/rpmbuild/RPMS/x86_64/*.rpm /work/rpms/ &&
        
        # Verify the copy worked
        echo "Contents of /work/rpms:" &&
        ls -l /work/rpms/
    '

echo "RPM build complete! RPMs can be found in the rpms/ directory:"
ls -l rpms/ 