#!/usr/bin/env bash
#Clears cache on an environment.

# Usage info
show_help() {
    cat <<"EOF"

usage:
    sh env-clear-cache.sh [<args>]
or
    cc [<args>]

These are the arguments that are accepted by the script:
    [-s=<site>] and [-e=<environment>]

Example usage:
    '$ sh env-clear-cache.sh -s yoursite -e dev'
    '$ cc -s yoursite -e dev'
    '$ cc'

To cancel a currently running command/script, press [Ctrl+C]

EOF
}

ALIAS="cc"

if [[ $1 == "-h" || $1 == "--help" ]]; then
    show_help
    exit 1
else
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
                echo " \033[1;97;46m[notice]\033[0m Invalid option: -$OPTARG"
                show_help
                exit 1
            ;;
            *)
                echo " $ALIAS: unknown option -$OPTARG. See '$ALIAS --help'."
                exit 1
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

    echo " \033[1;97;46m[notice]\033[0m Clearing cache on the \033[1;32;40m$ENV\033[0m environment..."
    terminus env:clear-cache $SITE.$ENV
fi