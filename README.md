# 🚀 My Awesome Secure CI/CD Pipeline on AWS!

Hey there! 👋 Welcome to my little corner of the internet where I've put together a really cool project: a fully automated and super secure CI/CD pipeline on AWS. This isn't just about deploying code; it's about doing it securely, right from the start!

I've used a bunch of awesome tools like Terraform to set up all the AWS magic (even deploying to EC2!) and then hooked it up with GitHub Actions to build, scan, test, and get my containerized apps running on Kubernetes. Oh, and managing those pesky secrets? I've got that covered with Kubernetes Sealed Secrets, so everything stays super safe.

Think of this as your go-to guide if you're into Infrastructure as Code (IaC), making sure your code is safe, and automating all the deployment fun.

## 🧱 What's the Big Picture? (My DevSecOps Architecture)

I've designed this project around a "GitOps" idea. Basically, my GitHub repository is the single source of truth for literally everything – from my app code to how the whole infrastructure is set up. Here's a quick peek at how it all flows:

```mermaid
flowchart TD
  direction TB

  subgraph Developer
    A["🧑‍💻 Push to GitHub"]
  end

  subgraph GitHub Actions
    B1["⚙️ CI Workflow"]
    B2["🧪 tfsec Scan"]
    B3["🔍 Trivy Scan"]
    B4["🔐 Seal Secrets"]
  end

  subgraph AWS Infrastructure
    C1["📦 S3 Bucket"]
    C2["🛠️ CodeBuild"]
    C3["🚀 CodeDeploy"]
    C4["🔁 CodePipeline"]
    C5["🔐 IAM Roles"]
  end

  subgraph Kubernetes Cluster
    D1["🧩 Sealed Secrets Controller"]
    D2["☸️ Deployments"]
  end

  A --> B1
  B1 --> B2 & B3 & B4
  B2 --> C4
  B3 --> C4
  B4 --> D1
  C4 --> C1 & C2 & C3 & C5
  C3 --> D2
  D1 --> D2
🔑 Why is this Project So Cool? (Key Highlights)
I'm pretty proud of these aspects:

Infrastructure as Code (IaC): Seriously, all my AWS stuff – CodePipeline, EC2 instances, S3 buckets, and even the IAM roles – it's all defined and managed by Terraform. No more clicking around manually!

Automated Security Checks: I've baked security right into the pipeline! tfsec sniffs out any potential security issues in my Terraform code, and Trivy scans my Docker images for known vulnerabilities. All automated, right when I push code.

Dual Deployment Power: This project actually shows off two ways to deploy! There's the classic way to AWS EC2 using CodeDeploy, and then the more modern way for containerized apps onto Kubernetes. Flexible, right?

Fully Automated & Super Fast: The CI/CD workflows kick off automatically with every single git push. This means I get super quick feedback on my changes and my apps are deployed in a flash.

Secrets, Safely Stored: Managing sensitive info like database passwords is a pain, but with Kubernetes Sealed Secrets, I can safely store encrypted secrets in my Git repository. Only the cluster can unseal them!

Infrastructure That Works (Proven!): I even used Terratest to write automated Go tests. This helps me make absolutely sure that my Terraform infrastructure is set up correctly and actually works as expected.

🧰 What Did I Use? (Tools & Technologies)
Here's a breakdown of the main tools and services that made this project happen:

Layer	Tools/Services
IaC	Terraform, Terratest
Cloud Platform	AWS (CodePipeline, CodeBuild, CodeDeploy, S3, IAM)
DevSecOps	tfsec, Trivy
CI/CD	GitHub Actions
Containers	Docker, Kubernetes
Secret Handling	Sealed Secrets
Languages	YAML, Go

Export to Sheets
⚙️ Want to Try It? (Setup Instructions)
It's pretty straightforward to get this up and running!

Step 1: Grab the Code!
First things first, get a copy of this repository onto your machine:

Bash

git clone [https://github.com/amit-kr-yash/DevOps-project.git](https://github.com/amit-kr-yash/DevOps-project.git)
cd DevOps-project
Step 2: Set up AWS
You'll need the AWS Command Line Interface (CLI) configured. If you haven't done this, run:

Bash

aws configure
Just follow the prompts to enter your AWS Access Key ID, Secret Access Key, and default region.

Step 3: Install Terraform
Make sure you have Terraform installed on your system. If not, head over to the official Terraform Docs for installation instructions.

Step 4: Create Your terraform.tfvars File
This file holds your specific project details and should not be committed to Git (it's in the .gitignore already, don't worry!). Create a new file named terraform.tfvars in the terraform/ directory and paste this content, filling in your details:

Terraform

project_name       = "myApp"
bucket_name        = "your-unique-artifact-bucket-name" # Make sure this is globally unique!
aws_region         = "your-region" # e.g., "us-east-1"
ami_id             = "ami-xxxx"    # Find a suitable AMI for your region, e.g., an Amazon Linux 2 AMI
instance_type      = "t3.micro"
key_name           = "your-key"    # Your EC2 Key Pair name
github_owner       = "your-user"   # Your GitHub username
github_repo        = "your-repo"   # The name of your app repository (not this one)
github_branch      = "main"
github_token       = "ghp_xxx"     # A GitHub Personal Access Token with 'repo' scope
instance_tag_key   = "Name"
instance_tag_value = "AppServer"
⚠️ Important: Never commit your terraform.tfvars file to version control! It contains sensitive information.

Step 5: Deploy the Infrastructure
Now, let's get that infrastructure up and running!

Bash

terraform init
terraform apply --auto-approve
This will get all your AWS resources provisioned. It might take a few minutes!

🛠️ How It All Comes Together
Here's a deeper dive into the two main parts of this project:

📦 Part 1: Setting up the AWS Infrastructure
First, Terraform does its magic! It provisions all these AWS resources for you:

An S3 bucket to store all your pipeline artifacts.

The necessary IAM roles and policies so each AWS service has just the right permissions.

The entire AWS CodePipeline, which defines the steps: getting your code from GitHub, building it, and then deploying it.

The AWS CodeBuild project and AWS CodeDeploy resources needed for the build and deployment stages.

I've also used Terratest here. It's a Go library that lets me write automated tests to make sure the infrastructure Terraform deployed is correct and works as expected. So, I can be confident everything's set up right!

📁 What Files Your App Repo Needs
To make CodeBuild and CodeDeploy happy, your actual application repository (the one you'll be pushing code to) needs a few specific files:

buildspec.yml: This file tells CodeBuild exactly how to build your application.

appspec.yml: This is for CodeDeploy, explaining how to deploy your app to your EC2 instance.

scripts/install.sh and scripts/start.sh: These are shell scripts that CodeDeploy uses to install and start your application on the EC2 server.

✅ How to Run Terratest (Locally)
If you want to run the infrastructure tests yourself, here's how:

Bash

go mod init devops-test # Only if you haven't initialized a Go module here before
go get [github.com/gruntwork-io/terratest/modules/terraform](https://github.com/gruntwork-io/terratest/modules/terraform)
Then, the test/terraform_pipeline_test.go file (which you can check out in the repo!) includes checks like:

Go

terraform.InitAndApply(t, options)
// This line makes sure the CodePipeline was created and its name isn't empty!
assert.NotEmpty(t, terraform.Output(t, options, "codepipeline_name"))
🔒 Part 2: DevSecOps with GitHub Actions
This is where the real security and automation magic happens right in GitHub!

a. Keeping Terraform Code Secure (tfsec)
I've got a GitHub Actions job that runs tfsec on my Terraform code. It's like an early warning system for any security misconfigurations before they even get deployed!

YAML

jobs:
  validate:
    steps:
      - uses: actions/checkout@v3
      - uses: hashicorp/setup-terraform@v2
      - run: terraform validate # Standard Terraform validation
      - uses: aquasecurity/tfsec-action@v1.0.0 # Here's the tfsec scan!
b. Building & Scanning Docker Images (Trivy)
Once the app is built into a Docker image, Trivy jumps in to scan it for any known vulnerabilities. Super important for container security!

YAML

jobs:
  scan:
    steps:
      - run: docker build -t app:latest . # Build that Docker image!
      - run: trivy image app:latest       # Then scan it for vulnerabilities!
c. Sealing Your Secrets (Securely!)
I use kubeseal (part of Sealed Secrets) to take a regular Kubernetes secret and encrypt it. This "sealed" version is safe to store in Git. When it hits the cluster, the Sealed Secrets controller unseals it, and only then is it a real secret!

Bash

# First, create a regular Kubernetes secret (but don't save this unencrypted!)
kubectl create secret generic creds --from-literal=key=value -o yaml > secret.yaml

# Then, encrypt it with your cluster's certificate
kubeseal --cert cert.pem < secret.yaml > sealed-secret.yaml
📂 Project Structure (Where Everything Lives)
Here's how I've organized the files in this repository. It should give you a good idea of where everything is:

DevOps-Masters-Project/
├── .github/workflows/         # My GitHub Actions workflows live here
│   └── devsecops-pipeline.yml # The main CI/CD workflow!
├── terraform/                 # All my Terraform config files
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── Dockerfile                 # The Dockerfile for building my application image
├── kubernetes/                # Kubernetes manifests for my app
│   ├── deployment.yaml
│   └── secrets/
│       └── mysecret.yaml      # My sealed secrets!
├── examples/                  # Handy example files like buildspec.yml, appspec.yml, and scripts
├── test/                      # Terratest files for testing my infrastructure
│   └── terraform_pipeline_test.go
├── .gitignore                 # What Git should ignore (like terraform.tfvars!)
├── README.md                  # You're reading it!
└── terraform.tfvars           # Your *local* variable overrides (keep it secret!)
🧪 Quick Pipeline Summary (GitHub Actions)
In a nutshell, here's what happens when I push code:

My code gets pushed, and GitHub Actions kicks off the CI workflow.

Terraform code gets validated and scanned for security issues.

My Docker image gets built and scanned for vulnerabilities.

Any secrets are encrypted and safely applied to the Kubernetes cluster.

Finally, my awesome app gets deployed to Kubernetes!

This entire project, including this README, is available on GitHub:
https://github.com/sameerkumar01/DevopsProject2