.EXPORT_ALL_VARIABLES:

TERRAFORM_DIRECTORY = src/infrastructure/
BUILD_DIRECTORY = .build

TF_VAR_build_directory = $(BUILD_DIRECTORY)

init:
	# Initialises the repository for local use.
	mkdir -p $(BUILD_DIRECTORY)
	mkdir -p $(BUILD_DIRECTORY)/lambdas
	terraform init src/infrastructure/

format:
	black src/ tests/
	terraform fmt -recursive src/infrastructure/

build:
	# Compiles all of the source code into artifacts for AWS.
	echo "This utility hasn't been written yet."

infrastructure:
	# Deploys the infrastructure in AWS.
	terraform apply src/infrastructure/

tests:
	# Runs the unit testing suite.
	echo "This utility hasn't been written yet."