# Pixl8 Translation Manager - CommandBox Commands

This project provides commands for pushing and pulling translations from Pixl8's Translation manager.

## Usage

### Setup

Before using the commands, you must setup your API credentials and API endpoint for your translation server:

```bash
# to set API key:
pixl8 translations setCredentials

# to set Endpoint:
pixl8 translations setEndpoint
```

Your endpoint should omit the trailing slash and include the API path. For example, `https://translations.mycompany.com/api/translations/v1`.

### Pushing translations

To push translations, use the `pixl8 translations push` command. Arguments:

1. `projectSlug` = ID of the project, you could extract this from the project's `box.json` file, for example
2. `projectVersion` = Version of the project to publish. Must be three point semver version number with no decorations. Suggest always using `0` for patch version. Examples: 0.5.0, 4.1.0, 4.2.0, etc.
3. `sourceDirectory` = Source directory in which `.properties` files live. For Preside extensions, projects, etc. this will be the `i18n` directory


### Pulling translations

To pull translations, use the `pixl8 translations pull` command. Arguments:

1. `projectSlug` = ID of the project, you could extract this from the project's `box.json` file, for example
2. `projectVersion` = Version of the project to pull. Must be three point semver version number with no decorations.
3. `targetDirectory` = Directory in which to install `.properties` files. For Preside extensions, projects, etc. this will be the `i18n` directory
4. `languages` = Comma separated list of language codes to pull. e.g. `es,fr,de`

### Pulling translations for an entire Preside project

Use the `pixl8 translations presideprojectpull` command to mass download translations for Preside, your project and all its extensions in one easy go! Arguments:

1. `projectSlug` = ID of the project, you could extract this from the project's `box.json` file, for example
2. `projectVersion` = Version of the project to pull. Must be three point semver version number with no decorations.
3. `rootDirectory` = Root directory of the Preside app. Expect there to be a `/preside` folder and an `/application` folder in this directory.
4. `languages` = Comma separated list of language codes to pull. e.g. `es,fr,de`