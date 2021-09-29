# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY A PYTHON FUNCTION TO AWS LAMBDA
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

provider "aws" {
	region = var.aws_region
	access_key = var.aws_access_key_id
	secret_key = var.aws_secret_access_key
}

terraform {
  required_providers {
    archive = "~> 1.3"
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# AWS LAMBDA ESPECIFICACIONES
# ----------------------------------------------------------------------------------------------------------------------

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/python/main.py"
  output_path = "${path.module}/python/main.py.zip"
}

# ----------------------------------------------------------------------------------------------------------------------
# DEPLOY LAMBDA FUNCTION
# ----------------------------------------------------------------------------------------------------------------------

module "lambda-function" {
  source  = "mineiros-io/lambda-function/aws"
  version = "~> 0.5.0"

  function_name = "python-function-service"
  description   = "Python Lambda function returns HTTP response."
  filename      = data.archive_file.lambda.output_path
  runtime       = var.env_lang
  handler       = "main.lambda_handler"
  timeout       = 30
  memory_size   = 128

  role_arn = module.iam_role.role.arn

  module_tags = {
    Name = "python-function-service"
    Environment = var.env
    Ceco = var.tag_ceco
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE AN IAM LAMBDA EXECUTION ROLE WHICH WILL BE ATTACHED TO THE FUNCTION
# ----------------------------------------------------------------------------------------------------------------------

module "iam_role" {
  source  = "mineiros-io/iam-role/aws"
  version = "~> 0.6.0"

  name = "python-function-role"

  assume_role_principals = [
    {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  ]

  tags = {
    Name = "python-function-role"
    Environment = var.env
    Ceco = var.tag_ceco
  }
}


resource "aws_iam_role_policy_attachment" "lambda-attach-policy-01" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AdministratorAccess", 
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  ])
  role       = module.iam_role.role.name
  #role       = module.iam_role.values.name
  policy_arn = each.value
}
