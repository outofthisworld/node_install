#!/bin/bash

##########################################
#                                        #
# SCRIPT TO SET UP DEVELOPER ENVIRONMENT #
#                                        #    
##########################################

NVM_LINK="https://raw.githubusercontent.com/creationix/nvm/v0.33.5/install.sh"

upd_node(){
    ## CREATE A SYMBOLIC LINK TO NVM ##
	sudo ln -s "${NVM_DIR}/nvm.sh" "/usr/local/bin" || sudo ln -s "${NVM_DIR}/nvm.sh" "/usr/bin" || echo "Failed to create symbolic link for nvm"
        
	## SOURCE THE NVM SCRIPT ##
	source "${NVM_DIR}/nvm.sh"
	local NVM_VERS="$(nvm --version)"
	
	#CHECK NVM INSTALLED CORRECTLY by checking nvm --version
	if [ -n ${NVM_VERS:-''} ] 
	then
	    if [ $(nvm ls ${1:-6} | grep N/A) ]; then
        	nvm install ${1:-6} && nvm use ${1:-6}
		else
			nvm use ${1:-6} 
		fi
		return $?
	fi
	return 1s
}


 if ! [[ $NODE_VERSION  =~ ^[0-9]+.?[0-9]*.?[0-9]*$ ]]
 then
 	echo "Invalid node version specified, must be a number in format [x[x.x..]] e.g (6),(6.2),(6.3.2)"
 	exit
 fi
 
if ! [ $(which curl) ] && ! [ $(which wget) ]; then
    ## attempt to download curl or wget
    which apt-get && apt-get install curl ||
    which yum && yum install curl ||
	which pacman && pacman install curl ||
	which port && port selfupdate && port install curl ||
	which brew && brew update && brew install curl || 
    echo "Could not find wget and no suitable package manager found to install curl, please install curl/wget manually" && exit
fi

if ! [ -d "${NVM_DIR}" ] || ! [ -f "${NVM_DIR}/install.sh" ]; then
    which curl && curl -o- ${NVM_LINK} 2> /dev/null | bash || which wget && wget -qO- ${NVM_LINK} 2> /dev/null | bash &&
	echo "Succesfully installed nvm.. checking path" && upd_node $1 && 
	echo "succesfully installed nvm via curl..installing node" ||
    echo "Could not find nvm on path."
else
    echo "nvm is already installed. changing version."
    upd_node $1
fi

exit