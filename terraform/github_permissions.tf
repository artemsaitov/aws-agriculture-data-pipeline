resource "aws_iam_role_policy" "github_terraform_plan" {
  name = "${var.project_name}-github-terraform-plan"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "ReadProjectInfrastructure"
        Effect = "Allow"

        Action = [
          "s3:Get*",
          "s3:List*",

          "lambda:Get*",
          "lambda:List*",

          "iam:Get*",
          "iam:List*",

          "scheduler:Get*",
          "scheduler:List*",

          "glue:Get*",

          "athena:Get*",
          "athena:List*",

          "sns:Get*",
          "sns:List*",

          "cloudwatch:Get*",
          "cloudwatch:List*",
          "cloudwatch:Describe*"
        ]

        Resource = "*"
      },

      {
        Sid    = "TerraformStateLock"
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]

        Resource = [
          "arn:aws:s3:::agri-pipeline-tfstate-8ba3c290/agriculture-data-pipeline/terraform.tfstate",
          "arn:aws:s3:::agri-pipeline-tfstate-8ba3c290/agriculture-data-pipeline/terraform.tfstate.tflock"
        ]
      },

      {
        Sid    = "TerraformStateBucket"
        Effect = "Allow"

        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]

        Resource = "arn:aws:s3:::agri-pipeline-tfstate-8ba3c290"
      }
    ]
  })
}