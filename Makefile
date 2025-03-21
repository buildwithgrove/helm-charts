####################################################
############# Makefile helper targets ##############
####################################################

.PHONY: list
list: ## List all make targets
	@${MAKE} -pRrn : -f $(MAKEFILE_LIST) 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | sort

.PHONY: help
.DEFAULT_GOAL := help
help: ## Prints all make target descriptions
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-60s\033[0m %s\n", $$1, $$2}'

####################################################
############# Helm dependency targets ##############
####################################################

.PHONY: validate_chart_dependencies
validate_chart_dependencies: ## Validate Helm dependency list to ensure all helm dependencies added are resolvable.
	@./dependency_validation.sh

####################################################
#############  Helm releases targets  ##############
####################################################

.PHONY: validate_gh_cli
validate_gh_cli: ## Validate if GitHub CLI is installed
	@if [ command -v gh ]; then \
		echo "GitHub CLI is not installed. Please review README for installation instructions."; \
		exit 1; \
	fi; \

.PHONY: release_chart
release_chart: validate_gh_cli ## Run GitHub Action release charter workflow to release new versions of ...
	@gh workflow run release.yml --repo buildwithgrove/helm-charts


include ./makefiles/claude.mk