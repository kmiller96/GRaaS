.EXPORT_ALL_VARIABLES:

TERRAFORM_DIRECTORY = src/infrastructure
LAMBDA_DIRECTORY = src/lambdas
BUILD_DIRECTORY = .build

TF_VAR_build_directory = $(BUILD_DIRECTORY)

init:
	# Initialises the repository for local use.
	mkdir -p $(BUILD_DIRECTORY)
	mkdir -p $(BUILD_DIRECTORY)/lambdas
	terraform init src/infrastructure/

format:
	black src/ tests/
	terraform fmt -recursive $(TERRAFORM_DIRECTORY)

build:
	# Compiles all of the source code into artifacts for AWS.
	## TODO: Convert this from being a hardcoded process to an abstract utility.
	cp $(LAMBDA_DIRECTORY)/messager/ -r .build/tmp/
	cd .build/tmp/ && pip install -r requirements.txt -t . && zip -r ../lambdas/messager.zip .

infrastructure:
	# Deploys the infrastructure in AWS.
	terraform apply $(TERRAFORM_DIRECTORY)
destroy:
	# Tearsdown the infrastructure.
	terraform destroy $(TERRAFORM_DIRECTORY)

tests:
	# Runs the unit testing suite.
	echo "This utility hasn't been written yet."