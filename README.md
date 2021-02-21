# lerna-yarn-test

Testing `file:` and `link:` specifiers with yarn and lerna. There are subtle differences, noted in the Findings section.

## Getting started

Requirements:

- Docker Daemon running in background
- Node v14

```sh
nvm use
yarn install
# This example uses a private registry
yarn start:registry
```

This will start a registry at http://0.0.0.0:4873. Via UI, login as `admin:admin`.

## Findings

- ✅ Lerna will respect both `file:` and `link:` specifiers for publishing. An actual version will be substituted.
  - Tested `file:` with `@myexample/b@<=0.0.3`
  - Tested `link:` with `@myexample/b@>=0.0.4`
- ✅ Yarn will make a symlink for dependencies using the `link:` specifier.
- ❌ Yarn will make a complete copied subtree of a dependency using the `file:` specifier (instead of a symlink). This seems like a bug. In large monorepo setups, this is a very expensive operation as well.

## tl,dr

Use `link:` specifiers. They don't appear to be part of the official NPM package.json spec, though it's fine for a yarn-based workflow.

### Reading

- https://medium.com/@alex_young/npm-5-and-file-urls-3c3631f7367c
- https://github.com/npm/npm/pull/15900
