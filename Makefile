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
	rm -rf .build/tmp/ && cp $(LAMBDA_DIRECTORY)/messager/ -r .build/tmp/
	cd .build/tmp/ && pip install -r requirements.txt -t . && zip -r ../lambdas/messager.zip .

	rm -rf .build/tmp/ && cp $(LAMBDA_DIRECTORY)/formatter/ -r .build/tmp/
	cp $(LAMBDA_DIRECTORY)/formatter/ -r .build/tmp/
	cd .build/tmp/ && pip install -r requirements.txt -t . && zip -r ../lambdas/formatter.zip .

	rm -rf .build/tmp/ && cp $(LAMBDA_DIRECTORY)/fetcher/ -r .build/tmp/
	cd .build/tmp/ && pip install -r requirements.txt -t . && zip -r ../lambdas/fetcher.zip .

	rm -rf .build/tmp/ && cp $(LAMBDA_DIRECTORY)/schedulers/weekly/ -r .build/tmp/
	cd .build/tmp/ && pip install -r requirements.txt -t . && zip -r ../lambdas/weekly_scheduler.zip .

	rm -rf .build/tmp/


infrastructure:
	terraform apply \
		-var-file=config/terraform.tfvars.json \
		$(TERRAFORM_DIRECTORY) 
destroy:
	terraform destroy \
		-var-file=config/terraform.tfvars.json \
		$(TERRAFORM_DIRECTORY) 


cli:
	pip install .
deploy: init build infrastructure
install: cli deploy


tests:
	# Runs the unit testing suite.
	echo "This utility hasn't been written yet."