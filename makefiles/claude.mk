#####################
### Claude targets ###
#####################

.PHONY: claudesync_check
# Internal helper: Checks if claudesync is installed locally
claudesync_check:
	@if ! command -v claudesync >/dev/null 2>&1; then \
		echo "claudesync is not installed. Make sure you review README.md before continuing"; \
		exit 1; \
	fi

.PHONY: claudesync_init
claudesync_init: claudesync_check ## Initializes a new ClaudeSync project
	@echo "###############################################"
	@echo "Initializing a new ClaudeSync project"
	@echo "When prompted, enter the following name: grove-helm-charts"
	@echo "When prompted, enter the following description: Claude Project for Grove's Helm Charts"
	@echo "When prompted for an absolute path, press enter"
	@echo "Follow the Remote URL outputted and copy-paste the recommended system prompt from the README"
	@echo "###############################################"
	@claudesync project init --new

.PHONY: claudesync_push
claudesync_push: claudesync_check ## Pushes the current project to the ClaudeSync project
	@claudesync push