init:
	conda env update --file environment.yaml --prune
	terraform init infrastructure/
.PHONY: init

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