#!/usr/bin/env bash
#Sets Git or SFTP connection mode on a development environment (excludes Test and Live).

# Usage info
show_help() {
    cat <<"EOF"
usage: mode <command> [<args>]

These are the available commands that can be passed to a script:
    sftp   Sets SFTP connection mode on a development environment (excludes Test and Live).
    git    Sets Git connection mode on a development environment (excludes Test and Live).

These are the options that can be passed to a script:
    [-s=<site>] and [-e=<environment>]
Arguments are optional. You'll be prompted to enter them, if skipped at script call.

Example usage:
    mode sftp -s mysite -e dev
    mode sftp
EOF
}

if [[ $# -eq 0 || $1 == "-h" || $1 == "--help" ]]; then
    show_help
elif [[ $1 == "git" || $1 == "sftp" ]]; then
    MODE=$1
    shift

    while getopts ":s:e:" option; do
        case "${option}" in
            s) SITE=${OPTARG};;
            e) ENV=${OPTARG};;
            :) echo " Option -$OPTARG requires an argument. See 'mode --help'.";;
            \?)
                echo " \033[1;97;46m[notice]\033[0m Invalid option: -$OPTARG" >&2
                show_help
                exit 1;;
            *) echo " mode: unknown option -$OPTARG. See 'mode --help'.";;
        esac
    done

    while [ -z $SITE ]; do
        printf " Provide the \033[1;32;40m[SITE]\033[0m name and press [ENTER]: "
        read -r SITE;
    done

    while [ -z $ENV ]; do
        printf " Provide the \033[1;32;40m[ENV]\033[0m name and press [ENTER]: "
        read -r ENV;
    done

    #Authenticate Terminus
    terminus auth:login

    #Set the $ENV environment's connection mode to $MODE
    echo " \033[1;97;46m[notice]\033[0m Setting \033[1;32;40m$SITE\033[0m.\033[1;32;40m$ENV\033[0m environment's connection mode to \033[1;32;40m$MODE\033[0m..."
    terminus connection:set $SITE.$ENV $MODE;
else
    echo " mode: <$1> is not a valid mode <command>. See 'mode --help'."
fi