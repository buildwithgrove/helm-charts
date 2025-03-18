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

.PHONY: chart_dependencies
validate_ chart_dependencies: ## Validate Helm dependency list to ensure all helm dependencies added are resolvable.
	@./dependency-validation.sh

####################################################
#############  Helm releases targets  ##############
####################################################

.PHONY: release_chart
release_chart: ## Run GitHub Action release charter workflow to release new versions of ...
	@gh workflow run release.yml --repo buildwithgrove/helm-charts