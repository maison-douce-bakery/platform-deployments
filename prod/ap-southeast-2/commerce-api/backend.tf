terraform {
  backend "s3" {
    key = "platform-deployments/prod/ap-southeast-2/commerce-api/terraform.tfstate"
  }
}
