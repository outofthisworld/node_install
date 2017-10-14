#!/bin/bash

##########################################
#                                        #
# SCRIPT TO SET UP DEVELOPER ENVIRONMENT #
#                                        #    
##########################################


NVM_LINK="https://raw.githubusercontent.com/creationix/nvm/v0.33.5/install.sh"


#NODE VERSION
NODE_VERSION="${1:-6}"

if ! [[ $NODE_VERSION  =~ ^[0-9]+.?[0-9]*.?[0-9]*$ ]]
then
	echo "Invalid node version specified, must be a number in format [x[x.x..]] e.g (6),(6.2),(6.3.2)"
	exit
fi

## FIRST, CHECK TO SEE IF WE HAVE CURL OR WGET ##

CURL_LOCATION="$(which curl > /dev/null 2>&1)"
WGET_LOCATION="$(which wget > /dev/null 2>&1)"


## IF WE DONT HAVE CURL OR WGET.. ATTEMPT TO GET IT USING A PACKAGE MANAGER
if ! [ -e $CURL_LOCATION ] && ! [ -e $WGET_LOCATION ]
then
	which apt-get && apt-get install curl ||
        which yum && yum install curl ||
	which pacman && pacman install curl ||
	which port && port selfupdate && port install curl ||
	which brew && brew update && brew install curl || 
        echo "Could not find wget and no suitable package manager found to install curl, please install curl/wget manually" && exit
fi

##WE HAVE CURL OR WGET.. USE TO DOWNLOAD NVM
which curl && curl -o- ${NVM_LINK} 2> /dev/null | bash || which wget && wget -qO- ${NVM_LINK} 2> /dev/null | bash && (
       
	 ## CREATE A SYMBOLIC LINK TO NVM ##
	sudo ln -s "${NVM_DIR}/nvm.sh" "/usr/local/bin" || sudo ln -s "${NVM_DIR}/nvm.sh" "/usr/bin" || echo "Failed to create symbolic link for nvm"
        
	## SOURCE THE NVM SCRIPT ##
	source "${NVM_DIR}/nvm.sh"
	NVM_VERS="$(nvm --version)"
	echo "nvm vers was ${NVM_VERS} node vers is ${NODE_VERSION}"
	
	#CHECK NVM INSTALLED CORRECTLY by checking nvm --version
	if [ -n $NVM_VERS ] 
	then
		echo "Succesfully installed ${NVM_VERS}"
		nvm install ${NODE_VERSION} && nvm use ${NODE_VERSION} && (
			 echo "Succesfully installed nvm at location ${NVM_DIR} using node ${NODE_VERSION}"
	        ) || echo "NVM install/use failed..."
	else
	   echo "Unknown error"
	fi
) || echo "Failed to install nvm from ${NVM_LINK}, please check install script is still available"



