# tf-aws-infra

## Prerequisites

- Install Terraform
- Install AWS CLI
- Configure AWS account - Do not use default profile.

## Getting Started

### 1. Clone the Repository

Start by cloning the repository to your local machine:

```bash
git clone <repository-url>
cd <repository-directory>
```

### 2. Create Your Variables File

Create a `.tfvars` file in the project directory to define your specific values for the variables. 

### 3. Export Your AWS Profile

If you are using a specific AWS profile, export it using the following command:

```bash
export AWS_PROFILE=your-profile-name
```

### 4. Initialize Terraform

Run the following command to initialize the Terraform project and download the necessary provider plugins:

```bash
terraform init
```

### 5. Plan Your Deployment

Preview the changes Terraform will make by running:

```bash
terraform plan -var-file="your-variables.tfvars"
```

### 7. Apply the Configuration

To apply the configuration and deploy your infrastructure, execute:

```bash
terraform apply -var-file="your-variables.tfvars"
```

Confirm the action when prompted. By typing Yes

### 8. Destroy Infrastructure**: To remove the infrastructure provisioned by Terraform, use:

    ```bash
    terraform destroy -var-file="your-variables.tfvars"
    ```