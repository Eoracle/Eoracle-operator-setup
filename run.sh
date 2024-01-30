#!/bin/bash
# process the arg 
cd data-validator
source .env 
cwd=$(pwd)

if [ -z "$ENCRYPTED_WALLET_PATH" ]; then
    private_path="--env-file .private_key" 
else
    private_path="--volume ${cwd}/${ENCRYPTED_WALLET_PATH}:/app/${ENCRYPTED_WALLET_PATH}"
fi

if [ "$1" == "encrypt" ]; then
    echo "PRIVATE_KEY=$2" > .private_key
    touch ${cwd}/${ENCRYPTED_WALLET_PATH}
    docker run --env-file .env --env-file .private_key --platform linux/amd64 --volume ${cwd}/${ENCRYPTED_WALLET_PATH}:/app/${ENCRYPTED_WALLET_PATH} ${EORACLE_OPERATOR_CLI_IMAGE} ${1}
    rm .private_key > /dev/null 2>&1
elif [ "$1" == "register" ] || [ "$1" == "deregister" ] || [ "$1" == "print_status" ] || [ "$1" == "decrypt" ]; then
    docker run --env-file .env ${private_path} --platform linux/amd64 ${EORACLE_OPERATOR_CLI_IMAGE} ${1}
else    
    # invalid arg
    echo "run.sh => Invalid argument: ${1}"
fi
cd ..
