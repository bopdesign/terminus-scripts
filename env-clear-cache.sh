#!/usr/bin/env bash
#Clears cache on an environment.

# Usage info
show_help() {
    cat <<"EOF"
usage: cc [<args>]

These are the options that can be passed to a script:
    [-s=<site>] and [-e=<environment>]
Arguments are optional. You'll be prompted to enter them, if skipped at script call.

Example usage:
    cc -s mysite -e dev
    cc
EOF
}

if [[ $# -eq 0 || $1 == "-h" || $1 == "--help" ]]; then
    show_help
else
    while getopts ":s:e:" option; do
        case "${option}"
        in
            s) SITE=${OPTARG};;
            e) ENV=${OPTARG};;
            :) echo " Option -$OPTARG requires an argument. See 'cc --help'.";;
            \?)
                echo " \033[1;97;46m[notice]\033[0m Invalid option: -$OPTARG"
                show_help
                exit 1;;
            *)
                echo " clear-cache: unknown option -$OPTARG. See 'cc --help'."
                exit 1;;
        esac
    done

    while [ -z $SITE ]; do
        printf " Provide the [\033[1;32;40m[SITE]\033[0m name and press [ENTER]: "
        read -r SITE;
    done

    while [ -z $ENV ]; do
        printf " Provide the \033[1;32;40m[ENV]\033[0m name and press [ENTER]: "
        read -r ENV;
    done
fi

#Authenticate Terminus
terminus auth:login

echo " \033[1;97;46m[notice]\033[0m Clearing cache on the \033[1;32;40m$ENV\033[0m environment..."
terminus env:clear-cache $SITE.$ENV