#!/usr/bin/env bash
#Sets Git or SFTP connection mode on a development environment (excludes Test and Live).

# Usage info
show_help() {
    cat <<"EOF"

usage:
    sh connection-set.sh <command> [<args>]
or
    mode <command> [<args>]

These are the commands that are accepted by the script:
    sftp   Sets SFTP connection mode on a development environment (excludes Test and Live).
    git    Sets Git connection mode on a development environment (excludes Test and Live).

These are the arguments that are accepted by the script:
    [-s=<site>] and [-e=<environment>]

Example usage:
    '$ sh connection-set.sh -s yoursite -e dev'
    '$ mode sftp -s yoursite -e dev'
    '$ mode sftp'

To cancel a currently running command/script, press [Ctrl+C]

EOF
}

ALIAS="mode"

if [[ $1 == "-h" || $1 == "--help" ]]; then
    show_help
    exit 1
elif [[ $1 == "git" || $1 == "sftp" ]]; then
    MODE=$1
    shift

    while getopts ":s:e:" option; do
        case "${option}" in
            s)
                SITE=${OPTARG}
            ;;
            e)
                ENV=${OPTARG}
            ;;
            :)
                echo " Option -$OPTARG requires an argument. See '$ALIAS --help'."
            ;;
            \?)
                echo " \033[1;97;46m[notice]\033[0m Invalid option: -$OPTARG" >&2
                show_help
                exit 1
            ;;
            *)
                echo " $ALIAS: unknown option -$OPTARG. See '$ALIAS --help'."
            ;;
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
    echo " mode: <$1> is not a valid $ALIAS <command>. See '$ALIAS --help'."
fi