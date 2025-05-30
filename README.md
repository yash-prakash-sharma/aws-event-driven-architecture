# AWS Event-Driven Architecture with Lambda, SQS, DynamoDB, S3, and SES

This project demonstrates an event-driven architecture using **AWS Lambda**, **Amazon SQS**, **Amazon DynamoDB**, **Amazon S3**, and **Amazon SES** to build a simple event-driven processing system. Infrastructure is managed using **Terraform**, and deployment pipelines are configured with **GitHub Actions** for seamless CI/CD.


## 🚀 Project Overview

The project includes:

* **AWS Lambda Function**: A Python-based Lambda function that processes messages from SQS, inserts data into DynamoDB, generates a receipt and uploads it to S3, and sends a notification email via SES.
* **Amazon SQS Queue**: Acts as the event trigger for the Lambda function, decoupling services and handling asynchronous processing.
* **Dead-Letter Queue (DLQ)**: Captures failed message deliveries for debugging and retry.
* **Amazon DynamoDB**: Stores processed data from the Lambda function for persistence and querying.
* **Amazon S3**: Stores generated receipts as files for later retrieval.
* **Amazon SES**: Sends email notifications with receipt details to a configured recipient.
* **Terraform Infrastructure**: Manages AWS resources and ensures repeatable, reliable deployments.
* **CI/CD Pipeline**: Uses GitHub Actions to automate Terraform deployments and Lambda updates.

---

## 🏗️ Architecture Overview

1. **SQS Queue**

   * Receives messages from upstream services.
   * Triggers the Lambda function upon message arrival.
   * Configured with a Dead-Letter Queue (DLQ) to capture failed processing attempts.

2. **Lambda Function**

   * Triggered by the SQS queue.
   * Parses and processes incoming messages.
   * Stores data in DynamoDB for persistence.
   * Generates a receipt (e.g., JSON or PDF) and uploads it to S3.
   * Sends an email notification (via SES) with receipt details or a link to the S3 object.

3. **DynamoDB**

   * Stores structured data related to the processed message for querying and record-keeping.

4. **S3**

   * Stores generated receipts securely and durably.
   * Provides URLs (pre-signed) for users to access receipts.

5. **SES (Simple Email Service)**

   * Sends email notifications to customers with order confirmation details.

6. **CI/CD Pipeline**

   * Built with GitHub Actions.
   * Automatically deploys infrastructure and Lambda code upon changes to the repository.

---

## ⚙️ Prerequisites

* **Terraform** (v1.11.3 or later)
* **AWS CLI** (configured with sufficient permissions)
* **GitHub** (for managing code and secrets)
* **Python** (for Lambda function code)

---

## 📝 Setup Instructions

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/yash-prakash-sharma/aws-event-driven-architecture.git
cd aws-event-driven-architecture
```

### 2️⃣ Configure AWS Credentials & other required resources

Ensure your AWS CLI is configured with credentials that have permissions to deploy Lambda, SQS, S3, SES, DynamoDB, and IAM resources.

Setup S3 bucket For Terraform Backend Manually and update in main.tf for dev environment

For GitHub Actions, configure **AWS OIDC** (OpenID Connect) authentication and store the role ARN in GitHub Secrets:

* `AWS_OIDC_ROLE_ARN`: The ARN of the OIDC role for GitHub Actions.

For SES notification and sender mail, create identity and get sender and reciever mail's verified as it provides a sandbox environment until requested for production:

* `SENDER_EMAIL`: Updated the field in terraform.tfvars with your SES verified sender email address.

### 3️⃣ Terraform Initialization

```bash
cd environments/dev  # or environments/prod
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -auto-approve -var-file=terraform.tfvars
```

### 4️⃣ CI/CD Configuration

GitHub Actions is preconfigured to:

* Checkout the repository.
* Setup Terraform.
* Configure AWS credentials using OIDC.
* Deploy infrastructure and Lambda changes automatically on `main` branch updates.

---

## 🧪 Testing the Workflow

1. **Send a Test Message to SQS**:

```bash
aws sqs send-message --queue-url $(terraform output -raw sqs_queue_url) --message-body '{"customer_id":"CUST789","total_amount":199.99,"shipping_address":"123 Main St, Springfield, IL, 62701","customer_email":"yourverifiedmail@gmail.com"}'
```

2. **Verify in DynamoDB**:

* Check for new items inserted corresponding to the message.

3. **Check S3 for Receipt**:

* The receipt should appear in the configured S3 bucket.

4. **Verify Email Notification**:

* Check the configured customer email inbox for receipt notification.

5. **Monitor CloudWatch Logs**:

```bash
aws logs tail /aws/lambda/YOUR_LAMBDA_FUNCTION_NAME --since 5m --follow
```

---

## 🗂️ Folder Structure

```
aws-event-driven-architecture/
├── environments
│   └── dev
│       ├── main.tf
│       ├── outputs.tf
│       ├── terraform.tfvars
│       └── variables.tf
│
├── modules
│   ├── dynamodb
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── iam
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── lambda
│   │   ├── code
│   │   │   └── lambda_function.py  # Lambda source code
│   │   ├── lambda_function.zip     # Zipped Lambda deployment package
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── s3
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── sqs
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
│
├── .github
│   └── workflows
│       └── terraform.yml           # GitHub Actions CI/CD workflow
│
└── README.md                       # Project documentation


```

---

## 🛠️ Troubleshooting

* **Lambda Not Triggering**: Check SQS subscription and Lambda event source mapping.
* **Missing DynamoDB Entries**: Verify IAM permissions for Lambda to write to DynamoDB.
* **No Receipt in S3**: Check the Lambda code and permissions for S3 bucket write access.
* **No Email Sent**: Confirm SES setup and verify the sender/recipient email is verified (in sandbox mode) also check spam section of email.
* **Terraform Apply Errors**: Validate AWS credentials and region configurations.

---

## 🤝 Contributing

Feel free to fork this repository, submit pull requests, and contribute improvements! Please ensure changes are well-documented and tested.

---

## 📜 License

This project is licensed under the MIT License. See the LICENSE file for details.