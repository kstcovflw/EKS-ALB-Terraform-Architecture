# How to reproduce 503 error

This guide will walk you through the setup and deployment of the project using Terraform. Follow these steps to configure and deploy your infrastructure.

## Step 1: Update Project Configuration

First, update the Terraform configuration to specify your project settings. Start by renaming the project bucket name in the Terraform variables.

### Update Variables

Edit the `variables.tf` in the `ready/` directory to set your project's bucket name for Terraform state management.

```hcl
variable "project_bucket_name" {
  type        = string
  description = "Bucket name for Terraform state files"
  default     = "your-unique-bucket-name"  # Replace with a unique bucket name
}
```

## Step 2: Configure Backend for Terraform

Next, link your backend configuration to the updated bucket name by modifying the `main.tf` in the `deployment/` directory.

### Update Backend Configuration

```hcl
backend "s3" {
  bucket = "your-unique-bucket-name"  # Ensure this matches the bucket name specified above

  # Additional backend configuration...
}
```

## Step 3: Create and Push Docker Image to AWS ECR

Create a Docker image for your Next.js application, which runs on port 3000. Follow the Next.js documentation for setup [Next.js documentation](https://nextjs.org/docs/getting-started/installation).

### Prepare the Dockerfile

Add this Dockerfile inside of your Next.js project directory, **not in the Terraform directory**:

```dockerfile
FROM node:latest

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

RUN npm run build

CMD ["npm", "start", "--", "-p", "3000"]
```

### Create and Push the Docker Image

First, authenticate your Docker client to your Amazon ECR registry:

```bash
aws ecr get-login-password --region your-region | docker login --username AWS --password-stdin your-account-id.dkr.ecr.your-region.amazonaws.com
```

Build the Docker image and tag it as `next-frontend:latest`:

```bash
docker build -t next-frontend:latest .
```

Create a repository in AWS ECR if it doesn't already exist:

```bash
aws ecr create-repository --repository-name next-frontend --region your-region
```

Tag your Docker image to match your repository in ECR:

```bash
docker tag next-frontend:latest your-account-id.dkr.ecr.your-region.amazonaws.com/next-frontend:latest
```

Finally, push the Docker image to your AWS ECR:

```bash
docker push your-account-id.dkr.ecr.your-region.amazonaws.com/next-frontend:latest
```

Replace variable with your actual ecr repo url
```variable "nextjs_docker_image" {
  description = "The Docker image for the Next.js application."
  // Replace with your actual image URL
  default     = "123456789012.dkr.ecr.us-east-1.amazonaws.com/next-frontend"
}
```
