terraform {
  backend "s3" {
    bucket       = "agri-pipeline-tfstate-8ba3c290"
    key          = "agriculture-data-pipeline/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}