# Migration for Firebird database

<p align="center">
  <a aria-label="License" href="https://github.com/Valdeirsk8/migrationFirebird/blob/master/LICENSE">
    <img alt="" src="https://img.shields.io/badge/license-MIT-green?style=flat-square">
  </a>
  <a aria-label="Version" href="https://github.com/Valdeirsk8/migrationFirebird">
    <img alt="" src="https://img.shields.io/badge/version-0.0.1-green.svg?style=flat-square">
  </a>
</p>
<p align="center">
  <a href="https://github.com/Valdeirsk8/migrationFirebird/blob/master/images/logoAndText.png">
    <img alt="Firebird Migration" height="200" src="https://github.com/Valdeirsk8/migrationFirebird/blob/master/images/logoAndText.png">
  </a>  
</p>

### Getting started

Installation:

- Download [setup](https://github.com/Valdeirsk8/migrationFirebird/releases)
- Just type `migration help` in cmd

## Available Commands

### > Init

This command initialize a new migration project

```
migration init
```

### > Init Migration

This command initialize a new migration to your project

```
migration init migration
migration init migration -d "Description"
```

### > Migrate

This command upgrade your database configured in your migration project

```
migration migrate
```

### > revert -to \<number\> | -all

This command revert your database to a point of time that you define

```
 migration revert -to 10
 migration revert -all
```

###### \<number\> that's an ID that you find on History_Migration table inside your database

### > Help

This is a helper for migration. Use `migration <command> help` for more information about a command.

```
migration help
```
