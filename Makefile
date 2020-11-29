SHELL := /bin/bash
.DEFAULT_GOAL := help
dir=.

#######################
# HELPER TARGETS
#######################

.PHONY: help
help:  ## help target to show available commands with information
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) |  awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: clear-cache
clear-cache:  ## clears the terraform cache folders to verify that always the newest terraform modules will be downloaded
	find . -type d -name ".terraform" -prune -exec rm -rf {} +

.SILENT: verify-aws-connection
verify-aws-connection:  ## clears the terraform cache folders to verify that always the newest terraform modules will be downloaded
	aws sts get-caller-identity --cli-connect-timeout=1 --cli-read-timeout=1 

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
# SSM TARGETS
#######################

.PHONY: get-instances
get-instances: ## create  a aws ssm session. Call make session t=<EC2_INSTANCE_NAME> e.g. make session t=i-0cd45ad30804b46f1
	aws ec2 describe-instances --query 'Reservations[*].Instances[*].{ID:InstanceId, type:InstanceType, launched:LaunchTime, State:State.Name}' --output table

.PHONY: list-subnets
list-subnets: ## list subnets
	aws ec2 describe-subnets --query 'Subnets[?MapPublicIpOnLaunch==`false`].{subnetid: SubnetId, VpcId: VpcId, Tags: Tags[*].Value}' --output table

#######################
# TERRAFORM TARGETS
#######################

.PHONY: init
init: ## create terraform init. Call make init [dir=<DIRECTORY>] e.g. make init dir=modules/ami/amazon
	cd ${dir} && terraform init

.PHONY: plan
plan: ## create terraform plan. Call make plan [dir=<DIRECTORY>] e.g. make plan dir=modules/ami/amazon
	cd ${dir} && terraform plan

.PHONY: apply
apply: ## create terraform apply. Call make apply [dir=<DIRECTORY>] e.g. make apply dir=modules/ami/amazon
	cd ${dir} && terraform apply

.PHONY: destroy
destroy: ## create terraform destroy. Call make destroy [dir=<DIRECTORY>] e.g. make destroy dir=modules/ami/amazon
	cd ${dir} && terraform destroy

.PHONY: docker-init
docker-init: ## create terraform init. Call make init [dir=<DIRECTORY>] e.g. make init dir=modules/ami/amazon
	docker-compose run dev sh -c "cd ${dir} && terraform init"
.PHONY: docker-plan
docker-plan: ## create terraform plan. Call make plan [dir=<DIRECTORY>] e.g. make plan dir=modules/ami/amazon
	cd ${dir} && docker-compose run dev sh -c "cd ${dir} && terraform plan"

.PHONY: docker-apply
docker-apply: ## create terraform apply. Call make apply [dir=<DIRECTORY>] e.g. make apply dir=modules/ami/amazon
	cd ${dir} && docker-compose run dev sh -c "cd ${dir} && terraform apply"

.PHONY: docker-destroy
docker-destroy: ## create terraform destroy. Call make destroy [dir=<DIRECTORY>] e.g. make destroy dir=modules/ami/amazon
	 cd ${dir} && docker-compose run dev sh -c "cd ${dir} && terraform destroy"

#######################
# GO
#######################

.PHONY: gotest
gotest: ## Run go unit tests
	 go test ./... -v

.PHONY: goget
goget: ## Update imports
	 go get -t -u ./...

#######################
# RELEASE
#######################

.PHONY: create-release
create-release: ## create release in github
	make validate
	make generate-docs
	docker-compose run -e GH_TOKEN=${GH_TOKEN} -e GIT_AUTHOR_NAME="${GIT_AUTHOR_NAME}" -e GIT_COMMITTER_NAME="${GIT_COMMITTER_NAME}" -e GIT_AUTHOR_EMAIL=${GIT_AUTHOR_EMAIL} -e GIT_COMMITTER_EMAIL=${GIT_COMMITTER_EMAIL} -e GITHUB_URL=http://github.conti.de/api/v3 release semantic-release --dry-run