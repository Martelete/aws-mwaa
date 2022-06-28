provider "aws" {
  region = var.region
}

provider "local" {
  version = "~>1.4"
}