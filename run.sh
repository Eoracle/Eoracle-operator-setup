#!/bin/bash
# process the arg 
cd data-validator
source .env

cwd=$(pwd)

if [ -z "$EO_KEYSTORE_PATH" ]; then
    private_path="--env-file .private_key"
else
    private_path="--volume ${cwd}/${EO_KEYSTORE_PATH}:/app/eoracle/${EO_KEYSTORE_PATH}:rw"
fi

if [ "$1" == "encrypt" ]; then
    if [ -z "$EO_KEYSTORE_PATH" ]; then
        echo "$EO_KEYSTORE_PATH is not set in .env"
        exit 1
    fi
    echo "ECDSA_PRIVATE_KEY=$2" > .private_key
    echo "BLS_PRIVATE_KEY=$3" >> .private_key
    docker run --env-file .env --env-file .private_key --platform linux/amd64 ${private_path} ${EO_OPERATOR_CLI_IMAGE} ${1}
    rm .private_key > /dev/null 2>&1
elif [ "$1" == "register" ] || [ "$1" == "deregister" ] || [ "$1" == "print-status" ] || [ "$1" == "decrypt" ] || [ "$1" == "generate-bls-key" ]; then
    _cmd=$1
    shift
    docker run --env-file .env ${private_path} --platform linux/amd64 ${EO_OPERATOR_CLI_IMAGE} "${_cmd} $@"
else    
    # invalid arg
    echo "run.sh => Invalid argument: ${1}"
fi
cd ..
