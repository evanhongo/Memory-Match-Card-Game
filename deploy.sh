#deploy to github pages

#!/usr/bin/env sh

# abort on errors
set -e

# build
npm run build

# navigate into the build output directory
cd dist

git init
git add .
git commit -m 'deploy'

git push -f https://github.com/evanhongo/Memory-Match-Card-Game.git master:gh-pages

cd -