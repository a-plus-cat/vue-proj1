#!/usr/bin/env sh

set -e
npm run build
cd dist

git init 
git add -A
git commit -m 'deploy'
git push -f git@github.com:a-plus-cat/vue-proj1.git master:gh-pages

cd -