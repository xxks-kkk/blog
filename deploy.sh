#!/bin/sh

set -e  # Exit with nonzero exit code if anything fails
set -vx # Display the command execution. For debug purpose.

SOURCE_BRANCH="master"
TARGET_BRANCH="master"
BLD_DIR="blog" # the build output directory (relative the root of the git repo)

# function doCompile
# {
#   tinker -b
# }

echo "$TRAVIS_PULL_REQUEST"
echo "$TRAVIS_BRANCH"

# Pull requests and commits to other branches shouldn't try to deploy, just build to verify
# if [ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != "SOURCE_BRANCH" ]; then
#     echo "Skipping deploy; just doing a build."
#     doCompile
#     exit 0
# fi

# Save some useful information
REPO=`git config remote.origin.url`
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
SHA=`git rev-parse --verify HEAD`

# Clone the existing gh-pages for this repo into $BLD_DIR/
# Create a new empty branch if gh-pages doesn't exist yet (should only happen on first deploy)
# rm -rf $BLD_DIR/**/* || exit 0
# git clone $REPO $BLD_DIR
# cd $BLD_DIR
# git checkout $TARGET_BRANCH || git checkout --orphan $TARGET_BRANCH
# cd ..

# Clean out existing contents
# rm -rf $BLD_DIR/**/* || exit 0

# Run our compile script
#doCompile

# cd $BLD_DIR
git config user.name "Travis CI"
git config user.email "$COMMIT_AUTHOR_EMAIL"

# If there are no changes to the compiled out then just bail
if [ -z `git diff --exit-code` 2> /dev/null ]; then
    echo "No changes to the output on this push; exiting."
    exit 0
fi

# Commit the "changes"
git commit -am "Deploy to GitHub Pages: ${SHA}"

# Get the deploy key by using Travis's stored variables to decrypt deploy_key.enc
ENCRYPTED_KEY_VAR="encrypted_${ENCRYPTION_LABEL}_key"
ENCRYPTED_IV_VAR="encrypted_${ENCRYPTION_LABEL}_iv"
ENCRYPTED_KEY=${!ENCRYPTED_KEY_VAR}
ENCRYPTED_IV=${!ENCRYPTED_IV_VAR}
openssl aes-256-cbc -K $ENCRYPTED_KEY -iv $ENCRYPTED_IV -in travis.enc -out travis -d
chmod 600 travis
eval `ssh-agent -s`
ssh-add travis

# Now that we're all set up, we can push.
git push $SSH_REPO $TARGET_BRANCH


