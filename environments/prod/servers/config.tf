terraform {
  backend "s3" {
    bucket = "ddogra1-acs730-project-prod"    // Bucket where to SAVE Terraform State
    key    = "prod-servers/terraform.tfstate" // Object name in the bucket to SAVE Terraform State
    region = "us-east-1"                      // Region where bucket is created
  }
}