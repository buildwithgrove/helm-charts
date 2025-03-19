#####################
### Claude targets ###
#####################

# - target: check if claudesync is installed
# - target: check if a pathd project exists -> show how to create one if not
# 	- name: pathd
# 	- Description: A claude project dedicated to the pathd CLI
# - target: update .claudesync to only include the pathd directory
# - target: run "claudesync push"

Enter a title for your project [helm-charts]: grove-helm-charts
Enter the project description [Project created with ClaudeSync]: Claude Project for Grove's Helm Charts


# .PHONY: check_kind
# # Internal helper: Checks if Kind is installed locally
# check_kind:
# 	@if ! command -v kind >/dev/null 2>&1; then \
# 		echo "kind is not installed. Make sure you review README.md before continuing"; \
# 		exit 1; \
# 	fi

# .PHONY: morse_e2e_config_warning
# morse_e2e_config_warning: ## Checks for required Morse E2E config file
# 	$(call check_config_exists,./e2e/.morse.config.yaml,prepare_morse_e2e_config)