BUILD_DIRECTORY ?= .build/

init:
	# Initialises the repository for local use.
	mkdir -p $(BUILD_DIRECTORY)
	terraform init src/infrastructure/

format:
	black src/ tests/
	terraform fmt -recursive src/infrastructure 

build:
	# Compiles all of the source code into artifacts for AWS.
	echo "This utility hasn't been written yet."

infrastructure:
	# Deploys the infrastructure in AWS.
	echo "This utility hasn't been written yet."

tests:
	# Runs the unit testing suite.
	echo "This utility hasn't been written yet."