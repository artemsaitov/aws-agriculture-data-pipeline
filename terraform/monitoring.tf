resource "aws_sns_topic" "pipeline_alerts" {
  name = "${var.project_name}-alerts"

  tags = {
    Project     = var.project_name
    Environment = "dev"
  }
}

resource "aws_cloudwatch_metric_alarm" "ingestion_errors" {
  alarm_name        = "${var.project_name}-ingestion-errors"
  alarm_description = "Alert when the ingestion Lambda reports errors"

  namespace   = "AWS/Lambda"
  metric_name = "Errors"

  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"

  dimensions = {
    FunctionName = aws_lambda_function.ingestion.function_name
  }

  alarm_actions = [
    aws_sns_topic.pipeline_alerts.arn
  ]

  treat_missing_data = "notBreaching"

  tags = {
    Project     = var.project_name
    Environment = "dev"
  }
}

resource "aws_cloudwatch_metric_alarm" "transformation_errors" {
  alarm_name        = "${var.project_name}-transformation-errors"
  alarm_description = "Alert when the transformation Lambda reports errors"

  namespace   = "AWS/Lambda"
  metric_name = "Errors"

  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"

  dimensions = {
    FunctionName = aws_lambda_function.transformation.function_name
  }

  alarm_actions = [
    aws_sns_topic.pipeline_alerts.arn
  ]

  treat_missing_data = "notBreaching"

  tags = {
    Project     = var.project_name
    Environment = "dev"
  }
}

resource "aws_sns_topic_subscription" "email_alerts" {
  topic_arn = aws_sns_topic.pipeline_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}