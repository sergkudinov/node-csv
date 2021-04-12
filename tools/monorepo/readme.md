
# Reorganize CSV.js to a monorepo

## Instructions

1. Install `git-filter-repo`

```
# For macOS
brew install git-filter-repo
```

Installation instructions - https://github.com/newren/git-filter-repo/blob/main/INSTALL.md

2. Run the script:

```
cd node-csv
./tools/monorepo/migrate.sh
```

> Note. To cleanup before migration run the command   
  ```
  rm -rf `ls -A | grep -v tools`
  ```

## Analysis

### Preserving commit history

The commit history will be preserved. It is possible using `--allow-unrelated-histories` option on `git merge` or `git pull` command. Tags and their messages are also preserved.

### Prefixing commits with package names

Template:

```
<package-name>: <old commit message>
```

There are 2 tools to rewrite commit messages: 

- `git filter-branch` - native, not recommended
- `git filter-repo` - external, officially recommended

Read more info - https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History#_the_nuclear_option_filter_branch

Example of rewriting commit messages using `git filter-repo`:

```
git filter-repo --message-callback '
  return b"<package-name>: " + message'
```

### Transferring issues

Issues can be transferred from one repo to another one by one using GitHub interface. Links between issues will be preserved. Instructions - https://docs.github.com/en/github/managing-your-work-on-github/transferring-an-issue-to-another-repository

### New structure

```
packages/
  csv
  csv-generate
  csv-parse
  csv-stringify
  stream-transform
tools/
  monorepo.sh
README.md
package.json
```

### Losses

1. Pull requests cannot be transferred. However links to issues in pull requests will be preserved.
