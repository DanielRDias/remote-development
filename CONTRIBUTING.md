# Contribution guide

## Developing remote-development

Thank you for considering to contribute to this project!
Please consider these guidelines when filing a pull request:

*  Commits follow the [Angular commit convention](https://github.com/angular/angular.js/blob/master/DEVELOPERS.md#-git-commit-guidelines)

## Creating releases

This project uses [semantic-release](https://github.com/semantic-release/semantic-release) to release new versions automatically.

*  Commits of type `fix` will trigger bugfix releases, think `0.0.1`
*  Commits of type `feat` will trigger feature releases, think `0.1.0`
*  Commits with `BREAKING CHANGE` in body or footer will trigger breaking releases, think `1.0.0`

All other commit types will trigger no new release.
