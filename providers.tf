provider "aws" {
  region = var.region
  # Use AWS credentials from environment variables or shared credentials file
  # AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables
  # or ~/.aws/credentials file will be used automatically
}