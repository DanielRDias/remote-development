SHELL := /bin/bash
.DEFAULT_GOAL := help

#######################
# HELPER TARGETS
#######################

.PHONY: help
help:  ## help target to show available commands with information
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) |  awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: clear-cache
clear-cache:  ## clears the terraform cache folders to verify that always the newest terraform modules will be downloaded
	find . -type d -name ".terraform" -prune -exec rm -rf {} +

.PHONY: build
build: ## build docker image for all tools
	docker-compose build

.PHONY: validate
validate: ## validate terraform
	docker-compose run dev terraform init
	docker-compose run dev terraform validate

#######################
# DOCS
#######################

.PHONY: init-docs
init-docs: ## generate markdown in README file with terragrunt-docs
	docker-compose run readme gitdown ./.README/README.md --output-file ./README.md

.PHONY: generate-docs
generate-docs: ## generate markdown in README file with terragrunt-docs
	docker-compose run docs terraform-docs-replace-012 markdown table README.md

.PHONY: generate-graph
generate-graph: ## generate reduced graph to show dependencies
	docker-compose run dev terraform init
	docker-compose run dev zsh -c "terraform graph -draw-cycles | grep -v meta.count-boundary | grep -v \"note\" | grep -v \"^.*[root]*module.*->.*[root]*module\" | dot -Tsvg > graph.svg"

#######################
# AWS TARGETS
#######################

.SILENT: verify-aws-connection
verify-aws-connection:  ## check connection to AWS by calling aws cli
	aws sts get-caller-identity --cli-connect-timeout=1 --cli-read-timeout=1

.PHONY: get-all-instances
get-all-instances: ## list all instances in the account
	aws ec2 describe-instances --query 'Reservations[*].Instances[*].{Name:Tags[?Key==`Name`]|[0].Value, ID:InstanceId, IP:PrivateIpAddress, type:InstanceType, launched:LaunchTime, State:State.Name}' --output table

.PHONY: get-instance
get-instance: ## get your remote development instance info
	aws ec2 describe-instances --query 'Reservations[*].Instances[*].{Name:Tags[?Key==`Name`]|[0].Value, ID:InstanceId, IP:PrivateIpAddress, type:InstanceType, launched:LaunchTime, State:State.Name}' --instance-ids $(shell jq -r '.outputs.instanceid.value|join(" ")' terraform.tfstate) --output table

.PHONY: stop-instances
stop-instances: ## stop your remote development instances
	aws ec2 stop-instances --instance-ids $(shell jq -r '.outputs.instanceid.value|join(" ")' terraform.tfstate)

.PHONY: start-instances
start-instances: ## start your remote development instances
	aws ec2 start-instances --instance-ids $(shell jq -r '.outputs.instanceid.value|join(" ")' terraform.tfstate)

.PHONY: list-subnets
list-subnets: ## list subnets
	aws ec2 describe-subnets --query 'Subnets[?MapPublicIpOnLaunch==`false`].{subnetid: SubnetId, VpcId: VpcId, Tags: Tags[*].Value}' --output table

#######################
# TERRAFORM TARGETS
#######################

.PHONY: init
init: ## create terraform init.
	terraform init

.PHONY: plan
plan: ## create terraform plan.
	terraform plan

.PHONY: apply
apply: ## create terraform apply.
	terraform apply

.PHONY: apply-log
apply-log: apply ## create terraform apply and show log.
	@while [ "$$(ssh -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $$USER@$$(terraform output -json privateip | cut -d'"' -f2) uname)" != "Linux" ]; \
		do \
			echo "## Retrying to connect while users's ssh key is being copied to instance.."; \
			sleep 5 ; \
		done
	@echo "## Tailing /var/log/cloud-init-output.log.. ^C to exit."
	@ssh -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $$USER@$$(terraform output -json privateip | cut -d'"' -f2) sudo tail -f /var/log/cloud-init-output.log

.PHONY: recreate
recreate: ## recreate terraform instance.
	terraform apply -var="destroy_instance=true"
	terraform apply

.PHONY: destroy
destroy: ## create terraform destroy.
	terraform destroy

.PHONY: docker-init
docker-init: ## create terraform init.
	docker-compose run dev terraform init

.PHONY: docker-plan
docker-plan: ## create terraform plan.
	docker-compose run dev terraform plan

.PHONY: docker-apply
docker-apply: ## create terraform apply.
	docker-compose run dev terraform apply

.PHONY: docker-recreate
docker-recreate: ## recreate terraform instance.
	docker-compose run dev terraform apply -var="destroy_instance=true"
	docker-compose run dev terraform apply

.PHONY: docker-destroy
docker-destroy: clean-all ## create terraform destroy.
	docker-compose run dev terraform destroy

#######################
# CLEANING
#######################

clean-all: ## Remove all zipped lambda functions
	@for dir in $$(/bin/ls -d ./lambda_*); \
	do \
		pushd $$dir > /dev/null; \
		rm -fr *.zip; \
		popd > /dev/null; \
	done

#######################
# RELEASE
#######################

.PHONY: create-release
create-release: validate generate-docs ## create release in github
	docker-compose run -e GH_TOKEN=${GH_TOKEN} -e GIT_AUTHOR_NAME="${GIT_AUTHOR_NAME}" -e GIT_COMMITTER_NAME="${GIT_COMMITTER_NAME}" -e GIT_AUTHOR_EMAIL=${GIT_AUTHOR_EMAIL} -e GIT_COMMITTER_EMAIL=${GIT_COMMITTER_EMAIL} -e GITHUB_URL=http://github.com/api/v3 release semantic-release --dry-run