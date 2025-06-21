####################################################
############# Makefile helper targets ##############
####################################################

.DEFAULT_GOAL := help

.PHONY: list help

list: ## List all make targets
	@${MAKE} -pRrn : -f $(MAKEFILE_LIST) 2>/dev/null | \
	  awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | \
	  egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | sort

help: ## Prints all make target descriptions
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	  awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-60s\033[0m %s\n", $$1, $$2}'

.DEFAULT:
	@echo "❌ Error: Target '$@' not found."
	@exit 1

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

################################################
#############  Helm Docs targets  ##############
################################################

.PHONY: check_helm_docs
check_helm_docs: ## Check if helm-docs is installed
	@if ! command -v helm-docs >/dev/null 2>&1; then \
		echo "helm-docs could not be found. Please install from releases page: https://github.com/norwoodj/helm-docs/releases/tag/v1.14.2"; \
		exit 1; \
	fi

.PHONY: generate_helm_values_docs
generate_helm_values_docs: check_helm_docs ## Generate the helm docs for the charts
	helm-docs -c ./charts/path -o docs/values.md -s file

################################################
#############  Additional Makefiles  ###########
################################################

include ./makefiles/claude.mk
