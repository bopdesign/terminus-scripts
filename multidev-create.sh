#!/usr/bin/env bash
#Creates a multidev environment.

# Usage info
show_help() {
    cat <<"EOF"
usage: mdcreate [<args>]

These are the options that can be passed to a script:
    [-m=<multidev>], [-s|--site=<site>] and [-f|--from-env=<FROM>]

Example usage:
    mdcreate -m multidev -s sitename -f dev
EOF
}

if [[ $# -eq 0 ]]; then
    echo " Not enough arguments. See 'mdcreate --help'." >&2
    show_help
    exit 1
else
    MD_NAME=""
    SITE=""
    FROM=""

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
                    while [ -z $FROM ]; do
                        printf " Provide the \033[1;32;40m[FROM]\033[0m environment name to create multidev on and press [ENTER]: "
                        read -r FROM;
                    done
                else
                    FROM="$2"
                    shift # past argument
                fi
            ;;
            *)
                echo " \033[1;97;41m[error]\033[0m Unknown option $1. See 'mdcreate --help'." >&2
                show_help
                exit 1
            ;;
        esac
        shift # past argument or value
    done

    if [[ -z $SITE && -z $FROM && -z $MD_NAME ]]; then
        #Final check in case our script failed to collect required info
        echo " Not enough arguments. See 'mdcreate --help'." >&2
        exit 1
    else
        #Authenticate Terminus
        terminus auth:login

        #Create a multidev environment on your awesome site
        echo " \033[1;97;46m[notice]\033[0m Creating a multidev environment - \033[1;32;40m$MD_NAME\033[0m on \033[1;32;40m$SITE\033[0m site from the \033[1;32;40m$FROM\033[0m environment."
        echo " \033[1;97;46m[notice]\033[0m Please stand by, this might take a minute or two..."
        terminus multidev:create $SITE.$FROM $MD_NAME

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