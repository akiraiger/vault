#!/bin/bash

vault="$HOME/.vault"
action="${1}"

init_vault() {
  mkdir -p ${vault}
  openssl genrsa -out ${vault}/key.txt 2048
}

print_help() {
  printf """
  vault.sh is a shell script for managing your secrets, such as password, API key, etc.
  
  vault.sh can be used interactively by using following actions:
    * 'help' to print this message
    * 'store <key> <secret>' to store secret
    * 'get <key>' to get secret and copy it to clipboard
    * 'list' to get list all of the keys you have
  """
}

no_arguments() {
  printf """
  You must provide an actions to use Vault.sh. Use 'help' for more information.
  """
}

unknown_action() {
  printf """
  Your action is not recognized. Use 'help' for more information.
  """
}

store_secret() {
  name=${1}
  secret=${2}
  echo ${secret} | openssl rsautl -inkey ${vault}/key.txt -encrypt > ${vault}/${name}
}

get_secret() {
  name=${1}
  secret=`openssl rsautl -inkey ${vault}/key.txt -decrypt < ${vault}/${name}`
  echo ${secret} | pbcopy
}

if [ ! -d ${vault} ] ; then init_vault ; fi
# if [ ! command -v openssl > /dev/null ] ; then printf "OpenSSL is not available" ; fi

if [ ${action} == "help" ] ; then print_help ;
elif [ ${action} == "store" ] ; then store_secret "$2" "$3" ;
elif [ ${action} == "get" ] ; then get_secret "$2" ;
elif [ $# -eq 0 ] ; then no_arguments ;
else unknown_action ; fi
