brew --prefix nvm > /dev/null 2>&1

if [[ "$?" == "0" ]]; then
	export NVM_DIR=~/.nvm
	source $(brew --prefix nvm)/nvm.sh
fi
