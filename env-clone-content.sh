#!/usr/bin/env bash
#Clones from one environment to the other on a specified site.

# Usage info
show_help() {
    cat <<"EOF"

usage:
    sh env-clone-content.sh [<args>] [options]
or
    clone [<args>] [options]

These are the arguments that are accepted by the script:
    [-s|--site=<site>], [-f|--from-env=<from_environment>], [-t|--to-env=<to_environment>] and [-b|--backup]

These are the available options:
    [--db-only] [--files-only] [-h|--help] [-q|--quiet] [-v|vv|vvv|--verbose]
    [-V|--version] [--ansi] [--no-ansi] [-n|--no-interaction] [-y|--yes] [--]

Example usage:
    '$ sh env-clone-content.sh -s yoursite -f dev -t test -e dev'
    '$ clone -s yoursite -f test -t dev'
    '$ clone -s yoursite -f test -t dev --db-only -v'

To cancel a currently running command/script, press [Ctrl+C]

EOF
}

ALIAS="clone"
SITE=""
FROM_ENV=""
TO_ENV=""
OPTIONALS=""
BACKUP=false

if [[ $# -eq 0 ]]; then
    echo " Not enough arguments. See '$ALIAS --help'." >&2
    show_help
    exit 1
else
    while [[ $# -gt 0 ]]; do
        key="$1"

        case $key in
            -h|--help)
                show_help
                exit 1
            ;;
            -s|--site)
                if [[ -z $2 || $2 == -* ]]; then
                    echo " \033[1;97;46m[notice]\033[0m Option $1 is missing an argument."
                    while [ -z $SITE ]; do
                        printf " Provide the \033[1;32;40m[SITE]\033[0m name to perform clone operation on and press [ENTER]: "
                        read -r SITE;
                    done
                else
                    SITE="$2"
                    shift # past argument
                fi
            ;;
            -f|--from-env)
                if [[ -z $2 || $2 == -* ]]; then
                    echo " \033[1;97;46m[notice]\033[0m Option $1 is missing an argument."
                    while [ -z $FROM_ENV ]; do
                        printf " Provide the environment name to clone \033[1;32;40m[FROM]\033[0m and press [ENTER]: "
                        read -r FROM_ENV;
                    done
                else
                    FROM_ENV="$2"
                    shift # past argument
                fi
            ;;
            -t|--to-env)
                if [[ -z $2 || $2 == -* ]]; then
                    echo " \033[1;97;46m[notice]\033[0m Option $1 is missing an argument."
                    while [ -z $TO_ENV ]; do
                        printf " Provide the environment name to clone \033[1;32;40m[TO]\033[0m and press [ENTER]: "
                        read -r TO_ENV;
                    done
                else
                    TO_ENV="$2"
                    shift # past argument
                fi
            ;;
            -b|--backup)
                BACKUP=true
            ;;
            *)
                # Since the terminus accepts much more optional parameters and does validation on their end,
                # we assume that these are the ones that user passed and store them in a variable
                # to pass it to the terminus.
                if [ -z $OPTIONALS ]; then
                    OPTIONALS="$1"
                else
                    OPTIONALS="$OPTIONALS $1"
                fi
            ;;
        esac
        shift # past argument or value
    done

    if [[ -z "$SITE" || -z "$FROM_ENV" || -z "$TO_ENV" ]]; then
        #Final check in case our script failed to collect required info
        echo " Not enough arguments. See '$ALIAS --help'."
        exit 1
    else
        #Authenticate Terminus
        terminus auth:login

        #If backup flag is passed, create a full backup of the $TO_ENV environment before cloning over it
        if $BACKUP; then
            echo " \033[1;97;46m[notice]\033[0m Creating a backup of a \033[32;49m$SITE\033[0m and \033[32;49m$TO_ENV\033[0m environment..."
            terminus backup:create $SITE.$TO_ENV
        fi

        #Clone database and file from $FROM_ENV to $TO_ENV environment (available options [--db-only] [--files-only])
        echo " \033[1;97;46m[notice]\033[0m Cloning content on \033[32;49m$SITE\033[0m from \033[32;49m$FROM_ENV\033[0m to \033[32;49m$TO_ENV\033[0m environment..."
        terminus env:clone-content $SITE.$FROM_ENV $TO_ENV $OPTIONALS

        echo " \033[1;97;46m[notice]\033[0m Clearing cache on the \033[32;49m$TO_ENV\033[0m environment..."
        terminus env:clear-cache $SITE.$TO_ENV
    fi
fi