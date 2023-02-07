# Remote Development

This project provides an easy-to-use remote development server.
With this server you can work from anywhere and develop remotely on any desktop.

## Why

1. **Develop in a different OS**: One of the most significant advantages is that it allows you to develop in the same OS as my production servers, but without using that same OS on my local PC. Or maybe you own a windows machine and want to develop in Linux.
2. **Same development experience from any device**: You have all your code and development environment in a remote server and connect to if from different devices. You will have the same developing experience working from your home, office, or any other device. If you forgot to git push, or your work isn't ready to be committed and pushed to a remote repository, continue working on it from a different computer just by connecting to your remote development server.
3. **Different or better hardware**: Need more RAM, CPU or GPU? Or maybe you just need a different CPU architecture AMD vs Intel.
4. **Run Time-Consuming Tasks**: For the data scientists/machine learning. I doubt you want to train your models on your laptop. Even if it's a simple-enough model and could be done reasonably enough with a laptop dGPU, I hope you have a full battery and it can be done in an hour. Remote development servers allow you to run time-consuming tasks because the server persists even when you're not directly connected to it.
5. **Team work**: How many times did you hear "works on my machine?" Your team can work with a machine with the same setup to ensure that everyone works with the same development environment. It is also an easy way to onboard new team members and saves time setting up the development environment.
6. **Projects with different requirements**: Sometimes, we have to work on projects with different hardware, OS, or software version requirements. Instead of managing multiple versions of a development framework, you can have multiple remote development servers configured to each specific project need.
7. **Easy to maintain**: Don't waste time searching in Stack Overflow or Server Fault because something got misconfigured. You can recreate your development environment and avoid wasting time with this. Treat your development machine like you treat your code.

## How to use

I'm currently only supporting **AWS** as target hosting for the remote development server, and I use **Terraform** to deploy the infrastructure.

### Prerequisites

1. [Install](https://github.com/aws/aws-cli#installation) and [configure](https://github.com/aws/aws-cli#configuration) [AWS CLI](https://aws.amazon.com/cli/)
2. Install [Terraform](https://www.terraform.io/)
3. SSH
   1. Windows 10 1803+ / Server 2016/2019 1803+
      1. [Install the Windows OpenSSH Client](https://docs.microsoft.com/windows-server/administration/openssh/openssh_install_firstuse).
   2. Earlier Windows
      1. Install [Git for Windows](https://git-scm.com/download/win).
   3. macOS
      1. Comes pre-installed.
   4. Debian/Ubuntu
      1. Run `sudo apt-get install openssh-client`
   5. RHEL / Fedora / CentOS
      1. Run `sudo yum install openssh-clients`

Optional:

[VS Code](https://code.visualstudio.com/) with [Remote Development](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack) or [Remote SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh) extension.

### Deploy remote development server

1) Configure your remote server

   Rename stage.auto.tfvars.example to stage.auto.tfvars and configure it for your needs.

2) Deploy the infrastructure

   Run `terraform init`

   Run `terraform apply` review what will be deployed, if you agree, type `yes` to deploy.

3) Configure the remote server access

   If you didn't configure the deployment with your own SSH a new key will be generated for you.

   Copy the code from `-----BEGIN RSA PRIVATE KEY-----` until `-----END RSA PRIVATE KEY-----` and save it in a file to be used as your private key.

   ![private key](docs/img/private_pem.png)

   Connect to the server using the private key and the server IP.

   Example: `ssh -i "C:\Users\Danie\.ssh\remotedev.pem" ec2-user@35.172.146.46`

   ![ssh](docs/img/ssh.png)

4) Delete the remote server

   To save costs, you can delete the server when you don't need it.

   By `terraform destroy` to delete all the infrastructure previously created.

### Configure VS Code to use the remote development server

1. Open VS Code Remote Explorer
2. Click to add a new SSH target
3. Type the SSH connection string to connect to the remote development server

   ![VS Code configure ssh](docs/img/vscode_ssh.png)

4. Save the connection in your SSH config file.
5. Connect to the remote development server

   ![VS Code Connect to remote server](docs/img/vscode_connect.png)

6. Now you are able to open a terminal and folders from the remote server directly in your VS Code.

   ![VS Code use remote server](docs/img/vscode_remote.png)

## More detailed information

Please note that this project targets Unix-like systems. If you use Windows,
you may want to install [Cygwin](http://www.cygwin.com/) in order to execute
`make` commands. Once installed, run `bash` and follow the instructions below.

If you have git installed, you can use the git bash. Windows start menu -> type git -> run git bash.

### Deploy remote development server

> Further commands that help you to setup the solution (using e.g. a docker environment) can be found in the Makefile in the root directory

1. Rename stage.auto.tfvars.example to stage.auto.tfvars and configure it for your needs.

2. Initialize the stage

   Option 1: use terraform directly

   ```bash
   make init
   ```

   Option 2: use docker

   ```bash
   make docker-init
   ```

### Start to build your infrastructure for the new stage

1. Execute Plan command to see the changes that will be executed

   Option 1: use terraform directly

   ```bash
   make plan
   ```

   Option 2: use docker

   ```bash
   make docker-plan
   ```

2. Generate infrastructure for this stage

   Option 1: use terraform directly

   ```bash
   make apply
   ```

   Option 2: use docker

   ```bash
   make docker-apply
   ```

#### Configure VS Code to use remote development server

1. Install the [Remote Development](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack) extension for VS Code
2. Configure your client for ssh remote login 
   1. Windows (with PuTTYgen) 
      - Install PuTTYgen and start it
      - Key -> generate Key pair -> Conversions -> Export OpenSSH key -> save it to desired location (e.g. C:\Users\uidxxxxx\.ssh)
      - follow instructions in https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh and https://code.visualstudio.com/docs/remote/troubleshooting#_reusing-a-key-generated-in-puttygen
      - Ensure that ~/.ssh/config and ~/.ssh/exported-keyfile-from-putty are accessible only by yourself. With right mouse -> Properties -> Security -> Remove all users access rights and add yourself as owner and the only user with full access 
3. Open the remote explorer, select SSH targets and configure the SSH connection for the remote development server.
4. Click to connect to Host
   1. It will open a new VS Code window connected to your remote host
   2. Open a terminal window in VS Code connected to the remote host
   3. Clone your git repo
      1. Example: `git clone git@github.com:DanielRDias/remote-development.git`
   4. Go to "File > Open..." Open the project folder in the remote server

#### Recreate the remote development machine instance keeping the data volume

   Option 1: use terraform directly

   ```bash
   make recreate
   ```

   Option 2: use docker

   ```bash
   make docker-recreate
   ```

#### Utility commands

List all available commands

```bash
make help
```

Check connection to AWS by calling aws cli

```bash
make verify-aws-connection
```

Get your remote development instance info

```bash
make get-instance
```

Stop your remote development instances

```bash
make stop-instances
```

Start your remote development instances

```bash
make start-instances
```

List subnets

```bash
make list-subnets
```

### FAQ

1) **Question**:

   I just created my new remote development server, but not all the software is installed.

   **Answer**:

   You can connect to the server even if the software installation is still in progress. The installation can take a few minutes. Once the installation is complete, you can open a new terminal, and all the software that was installed will be available for you to use.

2) **Question**

   If I have more than one project with different requirements, how can I deploy multiple machines based on each project requirement?

   **Answer**:

   You can create multiple clones of this repo for each project, configure each project with the specific needs, and update each project `application` tfvar with the project name.

   Example:

   `git clone git@github.com:DanielRDias/remote-development.git remote-dev-project1`

   Update stage.auto.tfvars application variable

   ```ini
   application       = "project1"
   ```

   `git clone git@github.com:DanielRDias/remote-development.git remote-dev-project2`

   Update stage.auto.tfvars application variable

   ```ini
   application       = "project2"
   ```

### Terraform versions

This project is currently being maintained using terraform 0.14.10
If you use a different version for your projects you can use our docker targets

### Upgrade from terraform 0.12 to 0.14

I recommend using tfenv to manage multiple terraform versions <https://github.com/tfutils/tfenv>

#### 0.12 -> 0.13

Using terrafrom version 0.13

If you have tfenv installed, you can switch the terraform version with the following commands:

```bash
tfenv install 0.13.6
tfenv use v0.13.6
```

```bash
terraform 0.13upgrade
terraform init
terraform plan
terraform apply
```

#### 0.13 -> 0.14

Using terrafrom version >=0.14

If you have tfenv installed, you can switch the terraform version with the following commands:

```bash
tfenv install 0.14.10
tfenv use v0.14.10
```

```bash
terraform init
terraform plan
terraform apply
```

### Terraform Docs

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.42, < 4.0 |
| <a name="requirement_cloudinit"></a> [cloudinit](#requirement\_cloudinit) | 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.3.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.76.1 |
| <a name="provider_cloudinit"></a> [cloudinit](#provider\_cloudinit) | 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.lambda_start_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_rule.lambda_stop_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.lambda_start_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_event_target.lambda_stop_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.cwlgroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_dlm_lifecycle_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dlm_lifecycle_policy) | resource |
| [aws_ebs_volume.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume) | resource |
| [aws_iam_instance_profile.profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.dlm_lifecycle_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.dlm_lifecycle](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.attachment1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.attachment2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.dev](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_kms_key.kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.lambda_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.lambda_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_resourcegroups_group.group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/resourcegroups_group) | resource |
| [aws_security_group.ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_volume_attachment.this_ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment) | resource |
| [archive_file.lambda_instance](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_ssm_parameter.ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [cloudinit_config.master](https://registry.terraform.io/providers/hashicorp/cloudinit/2.2.0/docs/data-sources/config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_DOCKERCOMPOSE_VERSION"></a> [DOCKERCOMPOSE\_VERSION](#input\_DOCKERCOMPOSE\_VERSION) | Software version installed to be installed in the remote development machine | `string` | `"1.27.4"` | no |
| <a name="input_GIT_EMAIL"></a> [GIT\_EMAIL](#input\_GIT\_EMAIL) | Your GitHub Email | `string` | `""` | no |
| <a name="input_GIT_NAME"></a> [GIT\_NAME](#input\_GIT\_NAME) | Your GitHub Name | `string` | `""` | no |
| <a name="input_TERRAFORM_VERSION"></a> [TERRAFORM\_VERSION](#input\_TERRAFORM\_VERSION) | Software version installed to be installed in the remote development machine | `string` | `"0.12.29"` | no |
| <a name="input_TERRAGRUNT_VERSION"></a> [TERRAGRUNT\_VERSION](#input\_TERRAGRUNT\_VERSION) | Software version installed to be installed in the remote development machine | `string` | `"v0.23.2"` | no |
| <a name="input_application"></a> [application](#input\_application) | n/a | `string` | `"remote-development"` | no |
| <a name="input_az"></a> [az](#input\_az) | n/a | `string` | `"eu-central-1a"` | no |
| <a name="input_backup_retention_days"></a> [backup\_retention\_days](#input\_backup\_retention\_days) | n/a | `number` | `7` | no |
| <a name="input_brew_packages"></a> [brew\_packages](#input\_brew\_packages) | List of brew packages to install. Seperated by SPACES. | `string` | `""` | no |
| <a name="input_custom_packages"></a> [custom\_packages](#input\_custom\_packages) | List of custom packages to install. Seperated by SPACES. | `string` | `""` | no |
| <a name="input_data_mount_point"></a> [data\_mount\_point](#input\_data\_mount\_point) | n/a | `string` | `"/data"` | no |
| <a name="input_data_volume"></a> [data\_volume](#input\_data\_volume) | n/a | `string` | `"/dev/sdh"` | no |
| <a name="input_data_volume_size"></a> [data\_volume\_size](#input\_data\_volume\_size) | n/a | `number` | `30` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | n/a | `map(string)` | <pre>{<br>  "Application": "remote-development",<br>  "Name": "remote-development",<br>  "Owner": "YOUR NAME/DEPARTMENT",<br>  "consolidation-unit": "YOUR CONSOLIDATION-UNIT",<br>  "cost-center": "YOUR COST-CENTER",<br>  "psp": "-"<br>}</pre> | no |
| <a name="input_destroy_instance"></a> [destroy\_instance](#input\_destroy\_instance) | Set to true if you want to destroy the instance but keep the data EBS volume | `bool` | `false` | no |
| <a name="input_ec2_instance_type"></a> [ec2\_instance\_type](#input\_ec2\_instance\_type) | n/a | `string` | `"t3a.micro"` | no |
| <a name="input_enable_backup"></a> [enable\_backup](#input\_enable\_backup) | n/a | `bool` | `false` | no |
| <a name="input_enable_scheduler"></a> [enable\_scheduler](#input\_enable\_scheduler) | Set to true if you want to start/stop your instance based on start/stop\_time | `bool` | `false` | no |
| <a name="input_fun_packages"></a> [fun\_packages](#input\_fun\_packages) | Install packages with fun included (neofetch, figlet, cowsay, lolcat,..) | `bool` | `false` | no |
| <a name="input_install_brew"></a> [install\_brew](#input\_install\_brew) | Set to true if you want to install brew.sh package manager | `bool` | `false` | no |
| <a name="input_npm_packages"></a> [npm\_packages](#input\_npm\_packages) | List of npm packages to install. Seperated by SPACES. | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"eu-central-1"` | no |
| <a name="input_root_volume_size"></a> [root\_volume\_size](#input\_root\_volume\_size) | n/a | `number` | `15` | no |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | Your public SSH key | `string` | n/a | yes |
| <a name="input_start_time"></a> [start\_time](#input\_start\_time) | Valid cron expression. e.g. cron(0 9 ? * MON-FRI *) | `string` | n/a | yes |
| <a name="input_stop_time"></a> [stop\_time](#input\_stop\_time) | Valid cron expression. e.g. cron(0 17 ? * MON-FRI *) | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_user_name"></a> [user\_name](#input\_user\_name) | n/a | `string` | `"YOURNAME"` | no |
| <a name="input_access_cidr"></a> [access\_cidr](#input\_access\_cidr) | IPs or network CIDR range allowed to connect to the remote development machine | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instanceid"></a> [instanceid](#output\_instanceid) | EC2 instance ID |
| <a name="output_privateip"></a> [privateip](#output\_privateip) | EC2 private IP |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
