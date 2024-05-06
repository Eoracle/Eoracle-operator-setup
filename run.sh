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
        echo "EO_KEYSTORE_PATH is not set in .env"
        exit 1
    fi
    echo "EO_ECDSA_PRIVATE_KEY=$2" > .private_key
    echo "EO_BLS_PRIVATE_KEY=$3" >> .private_key
    docker rm -f eoracle-operator-cli > /dev/null 2>&1
    docker run --name=eoracle-operator-cli --env-file .env --env-file .private_key --platform linux/amd64 ${private_path} ${EO_OPERATOR_CLI_IMAGE} ${1}
    rm .private_key > /dev/null 2>&1
else 
    _cmd=$1
    shift
    docker rm -f eoracle-operator-cli > /dev/null 2>&1
    docker run --name=eoracle-operator-cli --env-file .env ${private_path} --platform linux/amd64 ${EO_OPERATOR_CLI_IMAGE} "${_cmd} $@"
fi
cd ..
