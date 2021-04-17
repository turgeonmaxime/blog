#!/bin/sh

SRC_BRANCH="main"

git add --all && git commit --no-verify -m "Publishing source of blog to master branch" && git push origin master 

# Check if there are any uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo "Changes to the following files are uncommitted:"
    git diff-index --name-only HEAD --
    echo "Please commit the changes to master branch (which contains the source files of this blog) before proceeding."
    # Push to SRC_BRANCH
    #git add -fA
    #git commit --allow-empty -m "$(git log -1 --pretty=%B) [ci skip]"
    #git push -f -q origin $SRC_BRANCH
    echo "Aborting."
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

#DEPLOY_BRANCH="master"

echo "Deleting old publication"
# rm -rf public
# mkdir public
rm -rf .git/worktrees/public/
# 
# echo "Checking out gh-pages branch into public"
# git worktree add -B gh-pages public origin/gh-pages
# 
# echo "Removing existing files"
# rm -rf public

echo "worktree"
git worktree prune
git worktree add public gh-pages

echo "Generating site"
Rscript -e "blogdown::build_site()"

echo "Adding and committing to gh-pages branch"
cd public && git add --all && git commit -m "$1"

echo "Pushing to gh-pages branch"
git push origin gh-pages

echo "Cleaning up files"
cd ..
git worktree prune

rm -rf public