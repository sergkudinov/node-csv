#!/bin/sh

directory=packages
tmpdir="${TMPDIR}node-csv-tmp"
repos=(
  https://github.com/adaltas/node-csv
  https://github.com/adaltas/node-csv-generate
  https://github.com/adaltas/node-csv-parse
  https://github.com/adaltas/node-csv-stringify
  https://github.com/adaltas/node-stream-transform
)
# Initialize a new repo
[ -d .git ] && exit 0
git init
# Create tmp directory
rm -rf $tmpdir && mkdir $tmpdir
# Merge repos
for repo in ${repos[@]}; do
  # Get package name
  splited=(${repo//// })
  package=${splited[${#splited[@]}-1]/node-/}
  # Rewrite commit messages via tmp directory
  git clone $repo $tmpdir/$package
  git filter-repo \
    --source $tmpdir/$package \
    --target $tmpdir/$package \
    --message-callback "return b'chore(${package}): ' + message"
  # Pull from local tmp repo
  git remote add -f $package $tmpdir/$package
  git merge --allow-unrelated-histories $package/master -m "chore(${package}): merge branch 'master' of ${repo}"
  # Move files to subfolder
  mkdir -p $directory/$package
  files=$(find . -maxdepth 1 | egrep -v ^./tools$ | egrep -v ^./.git$ | egrep -v ^.$ | egrep -v ^./${directory}$)
  for file in ${files// /[@]}; do
    mv $file $directory/$package
  done
  # Commit moving files
  git add .
  git reset tools
  git commit -m "chore(${package}): move all package files to ${directory}/${package}"
done
# Commit migration files
git add .
git commit -m "chore: add migration files"
# Add monorepo files
cp -R tools/monorepo/assets/ .
git add .
git commit -m "chore: add monorepo files"
# Remove outdated documentation
rm packages/**/LICENSE
rm packages/**/CONTRIBUTING.md
rm packages/**/CODE_OF_CONDUCT.md
rm -rf packages/**/.github
git add .
git commit -m "chore: remove packages ducumentation files"
