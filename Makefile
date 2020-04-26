init:
	@conda env create --file environment.yaml --name graas || \
		echo "Environment 'graas' already exists. Skipping installation."
	terraform init infrastructure/
.PHONY: init

format:
	terraform fmt -recursive
	black .scripts/ src/ tests/
.PHONY: format

export:
	conda env export --no-builds | grep -v "prefix" > environment.yaml
.PHONY: export

diagram:
	python .scripts/build_solution_arch_diagram.py
.PHONY: diagram

update:
	@echo "This functionality hasn't been written yet."
.PHONY: update 

tests:
	python -m pytest tests/
.PHONY: tests

infrastructure:
	terraform apply infrastructure/
.PHONY: infrastructure

destroy:
	terraform destroy infrastructure/
.PHONY: destroy