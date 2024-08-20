##
## —————————————— MAKEFILE ————————————————————————————————————————————————————————
##
SHELL=/bin/sh

.DEFAULT_GOAL = help

.PHONY: help
help: ## Display help
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | sed -e 's/Makefile://' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-22s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'


.PHONY: header
header: ## Display some informations about local machine
	@echo "*********************************** MAKEFILE ***********************************"
	@echo "HOSTNAME	`uname -n`"
	@echo "KERNEL RELEASE 	`uname -r`"
	@echo "KERNEL VERSION 	`uname -v`"
	@echo "PROCESSOR	`uname -m`"
	@echo "********************************************************************************"

##
## —————————————————————————— ENVIRONMENTS CONFIGURATION ——————————————————————————
##
.PHONY: install-python
install-python: ## Easy way to install python
	@echo ""
	@echo "${Blue}******************************* INSTALL PYTHON ********************************${Color_Off}"
	@apt install -y python3 python3-pip python3-dev &&\
	 echo "[  ${Green}OK${Color_Off}  ] ${Yellow}PYTHON${Color_Off}" || \
	 echo "[${Red}FAILED${Color_Off}] ${Yellow}PYHTON${Color_Off}"

.PHONY: env
env: header ## Prepare environment
	@[ -d "${PWD}/.direnv" ] || (echo "Venv not found: ${PWD}/.direnv" && exit 1)
	@pip3 install -U pip --no-cache-dir --quiet &&\
	echo "[  ${Green}OK${Color_Off}  ] ${Yellow}INSTALL${Color_Off} pip3" || \
	echo "[${Red}FAILED${Color_Off}] ${Yellow}INSTALL${Color_Off} pip3"

	@pip3 install -U wheel --no-cache-dir --quiet &&\
	echo "[  ${Green}OK${Color_Off}  ] ${Yellow}INSTALL${Color_Off} wheel" || \
	echo "[${Red}FAILED${Color_Off}] ${Yellow}INSTALL${Color_Off} wheel"

	@pip3 install -U setuptools --no-cache-dir --quiet &&\
	echo "[  ${Green}OK${Color_Off}  ] ${Yellow}INSTALL${Color_Off} setuptools" || \
	echo "[${Red}FAILED${Color_Off}] ${Yellow}INSTALL${Color_Off} setuptools"

	@pip install -U --no-cache-dir -q -r requirements.txt &&\
	echo "[  ${Green}OK${Color_Off}  ] ${Yellow}INSTALL${Color_Off} PIP REQUIREMENTS" || \
	echo "[${Red}FAILED${Color_Off}] ${Yellow}INSTALL${Color_Off} PIP REQUIREMENTS"

.PHONY: prepare
prepare: header ## Install ansible-galaxy requirements
	@echo "***************************** ANSIBLE REQUIREMENTS *****************************"
	@ansible-galaxy install -fr ${PWD}/requirements.yml

##
## —————————————— CLEAN ———————————————————————————————————————————————————————————
##
.PHONY: clean
clean: ## Easy way to clean-up local environment
	@echo "${Green}Cleaning up environment${Color_Off}"
	@if test -d $(TEST_VBOX_DIRECTORY)/.vagrant; \
		then cd $(TEST_VBOX_DIRECTORY) && vagrant destroy -f && vagrant global-status --prune; \
		rm -rf $(TEST_VBOX_DIRECTORY)/.vagrant; \
	fi
	@rm -rf ./.direnv
	@rm -rf ./roles
	@rm -rf ./inventories

#
## —————————————— Tests ———————————————————————————————————————————————————————————
#
.PHONY: test_vbox
test_vbox: ## Test ansible role in vbox environment
	@echo "${Blue}Testing ansible role apply in VirtualBox environment${Color_Off}"
	@cd tests/vbox && vagrant up && vagrant provision
