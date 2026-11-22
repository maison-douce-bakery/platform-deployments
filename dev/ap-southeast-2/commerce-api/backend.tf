terraform {
  backend "s3" {
    key = "platform-deployments/dev/ap-southeast-2/commerce-api/terraform.tfstate"
  }
}
