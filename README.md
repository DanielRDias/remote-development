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

1) Select your hosting provider, infrastructure deployment framework, and remote server OS.

   Example:

   Hosting provider: AWS

   Infrastructure deployment framework: Terraform

   Remote server OS: Amazon Linux 2

   `cd aws/terraform/amazon-linux-2/`

2) Configure your remote server

   Open terraform.auto.tfvars and adjust the settings to your needs.

3) Deploy the infrastructure

   Note: Run the commands in the folder where you did the previous configuration. Example: `cd aws/terraform/amazon-linux-2/`

   Run `terraform init`

   Run `terraform apply` review what will be deployed, if you agree, type `yes` to deploy.

4) Configure the remote server access

   If you didn't configure the deployment with your own SSH a new key will be generated for you.

   Copy the code from `-----BEGIN RSA PRIVATE KEY-----` until `-----END RSA PRIVATE KEY-----` and save it in a file to be used as your private key.

   ![private key](docs/img/private_pem.png)

   Connect to the server using the private key and the server IP. 

   Example: `ssh -i "C:\Users\Danie\.ssh\remotedev.pem" ec2-user@35.172.146.46`

   ![ssh](docs/img/ssh.png)

5) Delete the remote server

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

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| aws | ~> 3.0 |

## Providers

No provider.

## Inputs

No input.

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
