#!/bin/sh

set -e  # Exit with nonzero exit code if anything fails
set -vx # Display the command execution. For debug purpose.

# Get the deploy key by using Travis's stored variables to decrypt deploy_key.enc
ENCRYPTED_KEY_VAR="encrypted_${ENCRYPTION_LABEL}_key"
ENCRYPTED_IV_VAR="encrypted_${ENCRYPTION_LABEL}_iv"
ENCRYPTED_KEY=${!ENCRYPTED_KEY_VAR}
ENCRYPTED_IV=${!ENCRYPTED_IV_VAR}
openssl aes-256-cbc -K $ENCRYPTED_KEY -iv $ENCRYPTED_IV -in travis.enc -out travis -d
chmod 600 travis
eval `ssh-agent -s`
ssh-add travis

# The main idea is to clone the same repo (i.e. travis-dup) and copy the bld output pages
# (under /xxks-kkk/blog/blog) to the bld directory of the same repo we just cloned (i.e. 
# travis-dup/blog). If there is nothing changed in the bld output pages, we exit. Else,
# we commit the changes and use the authencation we just added (i.e. ssh-add travis) and
# push the change to the repo

original_repo=`pwd` #/home/travis/build/xxks-kkk/blog

REPO=`git config remote.origin.url`
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
SHA=`git rev-parse --verify HEAD`

cd $HOME
git clone $REPO travis-dup
cd travis-dup

cd blog
rm -rf *
cp -r $original_repo/blog/* .

# If there are no changes to the compiled out then just bail
if [ -z `git diff --exit-code` 2> /dev/null ]; then
    echo "No changes to the output on this push; exiting."
    exit 0
fi

git config --global user.name "Travis CI"
git config --global user.email "$COMMIT_AUTHOR_EMAIL"

git status

num_file_changed=`git diff --name-only | wc -l`
file_changed=`git diff --name-only`
echo $file_changed

if [ "$num_file_changed" -eq 1 -a "$file_changed" == "blog/doctrees/environment.pickle" ]; then
  git checkout doctrees/environment.pickle
  exit 0
fi

git add -u
git add -A
git commit -m "Deploy the build: ${SHA}"
git status

git push $SSH_REPO master


# # Pull requests and commits to other branches shouldn't try to deploy, just build to verify
# # if [ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != "SOURCE_BRANCH" ]; then
# #     echo "Skipping deploy; just doing a build."
# #     doCompile
# #     exit 0
# # fi


