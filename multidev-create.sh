#!/usr/bin/env bash
#Creates a multidev environment.

# Usage info
show_help() {
    cat <<"EOF"

usage:
    sh multidev-create.sh [<args>]
or
    mdcreate [<args>]

These are the arguments that are accepted by the script:
    [-m=<multidev>], [-s|--site=<site>] and [-f|--from-env=<FROM_ENV>]

Example usage:
    '$ sh multidev-create.sh -m multidev -s yoursite -f dev'
    '$ mdcreate -m multidev -s yoursite -f dev'

To cancel a currently running command/script, press [Ctrl+C]

EOF
}

ALIAS="mdcreate"
MD_NAME=""
SITE=""
FROM_ENV=""

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
            -m|--multidev)
                if [[ -z $2 || $2 == -* ]]; then
                    echo " \033[1;97;46m[notice]\033[0m Option $1 is missing an argument."
                    while [ -z $MD_NAME ]; do
                        printf " Provide the multidev name to create \033[1;32;40m[MD_NAME]\033[0m and press [ENTER]: "
                        read -r MD_NAME;
                    done
                else
                    MD_NAME="$2"
                    shift # past argument
                fi
            ;;
            -s|--site)
                if [[ -z $2 || $2 == -* ]]; then
                    echo " \033[1;97;46m[notice]\033[0m Option $1 is missing an argument."
                    while [ -z $SITE ]; do
                        printf " Provide the \033[1;32;40m[SITE]\033[0m name to create multidev on and press [ENTER]: "
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
                        printf " Provide the \033[1;32;40m[FROM_ENV]\033[0m environment name to create multidev on and press [ENTER]: "
                        read -r FROM_ENV;
                    done
                else
                    FROM_ENV="$2"
                    shift # past argument
                fi
            ;;
            *)
                echo " \033[1;97;41m[error]\033[0m Unknown option $1. See '$ALIAS --help'." >&2
                show_help
                exit 1
            ;;
        esac
        shift # past argument or value
    done

    if [[ -z $SITE || -z $FROM_ENV || -z $MD_NAME ]]; then
        #Final check in case our script failed to collect required info
        echo " Not enough arguments. See '$ALIAS --help'." >&2
        exit 1
    else
        #Authenticate Terminus
        terminus auth:login

        #Create a multidev environment on your awesome site
        echo " \033[1;97;46m[notice]\033[0m Creating a multidev environment - \033[1;32;40m$MD_NAME\033[0m on \033[1;32;40m$SITE\033[0m site from the \033[1;32;40m$FROM_ENV\033[0m environment."
        echo " \033[1;97;46m[notice]\033[0m Please stand by, this might take a minute or two..."
        terminus multidev:create $SITE.$FROM_ENV $MD_NAME

        # Display connection info of a newly created environment
        echo "";
        echo " \033[1;97;46m[notice]\033[0m Getting a connection info for a newly created \033[1;32;40m$MD_NAME\033[0m environment..."
        terminus connection:info $SITE.$MD_NAME

        #Set the $MDNAME environment's connection mode to SFTP
        echo " \033[1;97;46m[notice]\033[0m Setting \033[1;32;40m$SITE\033[0m.\033[1;32;40m$MD_NAME\033[0m environment's connection mode to SFTP..."
        terminus connection:set $SITE.$MD_NAME sftp

        #Open the new multidev environment on the Site Dashboard
        terminus dashboard:view $SITE.$MD_NAME
    fi
fi