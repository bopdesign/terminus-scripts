# Terminus Scripts

This is a project for the [Pantheon](https://pantheon.io/) clients, who want to utilize it's command line interface, [Terminus](https://pantheon.io/docs/terminus/).
The scripts are meant to ease the everyday work with Terminus, so you don't have to remember all the commands and parameters.

## Requirements

**This project uses shell aliases to call scripts as commands, however it's not required.** So you can call a script using the syntax:
```bash
$ sh terminus-scripts/[script-name].sh command options
```

If you have not worked with a shell files before, I would recommend reading [The Bash Shell Startup Files](http://www.linuxfromscratch.org/blfs/view/7.6/postlfs/profile.html), a post that explains what you need to know.
Most crucial files to setup would be - `/etc/profile`, `~/.bash_profile` and `~/.bashrc`.

## Quickstart

### 1. Enter a folder to clone the repository to:
```bash
$ cd my-working-folder/
$ git clone https://github.com/bopdesign/terminus-scripts.git
```

### 2. While you're working on your project, run:
```bash
$ sh path-to-scripts/terminus-scripts/connection-set.sh sftp -s yoursite -e dev
```
This will set `yoursite` connection of `dev` environment to `sftp` mode (excludes Test and Live)

If you have an alias called `mode`, which runs the `connection-set.sh` script, you can alternatively type this:
```bash
$ mode sftp -s yoursite -e dev
```

## Contents
This is the list of currently available script files.
Each script contains documentation on how to use it, which can be accessed by calling a script with the standard flag `-h` or `--help`

* `multidev-create.sh` - creates a multidev environment
* `connection-set.sh` - sets Git or SFTP connection mode on a development environment (excludes Test and Live)
* `env-clone-content.sh` - clones from one environment to the other on a specified site
* `env-clear-cache.sh` - clears cache on an environment