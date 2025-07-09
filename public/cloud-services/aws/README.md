# AWS Deployment Scripts

Comprehensive scripts for deploying applications to various AWS services.

## 📁 Available Services

### Compute Services
- **EC2** - Elastic Compute Cloud virtual servers
- **ECS** - Elastic Container Service
- **Lambda** - Serverless functions
- **Elastic Beanstalk** - Platform-as-a-Service
- **Lightsail** - Simplified cloud platform

### Container Services
- **EKS** - Elastic Kubernetes Service
- **Fargate** - Serverless containers
- **ECR** - Elastic Container Registry

### Storage Services
- **S3** - Simple Storage Service
- **EFS** - Elastic File System
- **EBS** - Elastic Block Store

### Database Services
- **RDS** - Relational Database Service
- **DynamoDB** - NoSQL database
- **ElastiCache** - In-memory caching

## 🚀 Quick Start

### Prerequisites
```bash
# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Configure credentials
aws configure
```

### Deploy to EC2
```bash
cd ec2
./deploy.sh
```

### Deploy to Lambda
```bash
cd lambda
./deploy.sh
```

## 🔧 Configuration

Set up your AWS credentials and region:

```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

## 📝 Common Features

All AWS deployment scripts include:
- ✅ IAM role and policy setup
- ✅ Security group configuration
- ✅ VPC and subnet setup
- ✅ Load balancer configuration
- ✅ Auto-scaling setup
- ✅ CloudWatch monitoring
- ✅ SSL certificate management
- ✅ Backup and disaster recovery