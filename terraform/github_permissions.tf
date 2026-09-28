resource "aws_iam_role_policy" "github_terraform_plan" {
  name = "${var.project_name}-github-terraform-plan"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "DeployProjectInfrastructure"
        Effect = "Allow"

        Action = [
          # Lambda
          "lambda:CreateFunction",
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration",
          "lambda:DeleteFunction",
          "lambda:AddPermission",
          "lambda:RemovePermission",
          "lambda:TagResource",
          "lambda:UntagResource",

          # S3
          "s3:CreateBucket",
          "s3:DeleteBucket",
          "s3:PutBucketVersioning",
          "s3:PutEncryptionConfiguration",
          "s3:PutBucketPublicAccessBlock",
          "s3:PutBucketNotification",
          "s3:PutBucketTagging",
          "s3:DeleteBucketTagging",

          # EventBridge Scheduler
          "scheduler:CreateSchedule",
          "scheduler:UpdateSchedule",
          "scheduler:DeleteSchedule",
          "scheduler:TagResource",
          "scheduler:UntagResource",

          # Glue
          "glue:CreateDatabase",
          "glue:UpdateDatabase",
          "glue:DeleteDatabase",
          "glue:CreateTable",
          "glue:UpdateTable",
          "glue:DeleteTable",

          # Athena
          "athena:CreateWorkGroup",
          "athena:UpdateWorkGroup",
          "athena:DeleteWorkGroup",

          # CloudWatch
          "cloudwatch:PutMetricAlarm",
          "cloudwatch:DeleteAlarms",
          "cloudwatch:TagResource",
          "cloudwatch:UntagResource",

          # SNS
          "sns:CreateTopic",
          "sns:DeleteTopic",
          "sns:SetTopicAttributes",
          "sns:Subscribe",
          "sns:Unsubscribe",
          "sns:TagResource",
          "sns:UntagResource",

          # IAM
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:UpdateAssumeRolePolicy",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:TagRole",
          "iam:UntagRole",
          "iam:PassRole"
        ]

        Resource = "*"
      },

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