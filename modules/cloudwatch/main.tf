############ Monitoring with CloudWatch ##################

resource "aws_cloudwatch_dashboard" "petclinic-dashboard" {
  dashboard_name = "petclinic-dashboard"
  dashboard_body = jsonencode({
    "widgets": [
      {
        "type": "explorer",
        "width": 24,
        "height": 15,
        "x": 0,
        "y": 0,
        "properties": {
          "metrics": [
            {
              "metricName": "CPUUtilization",
              "resourceType": "AWS::EC2::Instance",
              "stat": "Average"
            },
            {
              "metricName": "NetworkIn",
              "resourceType": "AWS::EC2::Instance",
              "stat": "Average"
            },
            {
              "metricName": "NetworkOut",
              "resourceType": "AWS::EC2::Instance",
              "stat": "Average"
            }
          ],
          "aggregateBy": {
            "key": "InstanceType",
            "func": "MAX"
          },
          "labels": [
            {
              "key": "State",
              "value": "running"
            }
          ],
          "widgetOptions": {
            "legend": {
              "position": "bottom"
            },
            "view": "timeSeries",
            "rowsPerPage": 8,
            "widgetsPerRow": 2
          },
          "period": 120,
          "splitBy": "AvailabilityZone",
          "title": "Running EC2 Instances by AZ AND db-instances-alarm"
        }
      }
    ]
  })
}


resource "aws_cloudwatch_log_group" "eks_logs" {
  name              = var.eks_logs_name
  retention_in_days = 30
}

resource "aws_cloudwatch_log_stream" "eks_log_stream" {
  name           = "eks_logs"
  log_group_name = aws_cloudwatch_log_group.eks_logs.name
}



resource "aws_cloudwatch_metric_alarm" "eks_cpu_alarm" {
  alarm_name          = "eks-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EKS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This alarm monitors CPU utilization on EKS nodes."
  alarm_actions       = [aws_sns_topic.notification.arn]
  ok_actions = [aws_sns_topic.notification.arn]


  dimensions = {
    ClusterName = var.cluster_name
  }
}

resource "aws_cloudwatch_metric_alarm" "eks_memory_alarm" {
  alarm_name          = "eks-memory-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/EKS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This alarm monitors memory utilization on EKS nodes."
  alarm_actions       = [aws_sns_topic.notification.arn]
  ok_actions = [aws_sns_topic.notification.arn]


  dimensions = {
    ClusterName = var.cluster_name
  }
}

resource "aws_sns_topic" "notification" {
  name = "eks-notifications"
}

#
resource "aws_sns_topic_subscription" "email" {
  topic_arn = var.sns_topic_arn
  protocol  = "email"
  endpoint  = var.email
}

####STORAGE

resource "aws_cloudwatch_metric_alarm" "rds_cloudwatch_alarm_storage_80" {
  count = var.create_storage_80_alert && var.create_alarms ? 1 : 0

  alarm_name          = "rds-alarm-storage-${var.database_identifier[count.index]}-80"
  alarm_description   = "Free storage space on ${var.database_identifier[count.index]} is less then 80% (${var.database_storage * 0.2}/${var.database_storage} GB) "
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  threshold           = var.database_storage * 1073741824 * 0.2
  statistic           = "Average"
  #provider            = aws

  alarm_actions = [aws_sns_topic.notification.arn]

  ok_actions = [aws_sns_topic.notification.arn]
}

# CONNECTION COUNT


resource "aws_cloudwatch_metric_alarm" "rds_cloudwatch_alarm_conn_count_80" {
  count               = var.create_connection_count_80_alert && var.create_alarms ? 1 : 0
  alarm_name          = "rds-alarm-conn-count-${var.database_identifier[count.index]}-80"
  alarm_description   = "Connections count on ${var.database_identifier[count.index]} reached 80% of maximum ${var.max_connection_count}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = 300
  threshold           = floor(var.max_connection_count * 0.8)
  statistic           = "Maximum"
  provider            = aws
  alarm_actions       = [aws_sns_topic.notification.arn]
  ok_actions          = [aws_sns_topic.notification.arn]
}

data "template_file" "dd_message_rds_status" {
  template = "{{#is_alert}}\nRDS {{ host }} is in state **{{ value }}** (see below)\n\n2:   failed\n3:   inaccessible-encryption-credentials\n4:   incompatible-network\n5:   incompatible-option-group\n6:   incompatible-parameters\n7:   incompatible-restore\n8:   maintenance\n9:   moving-to-vpc\n10: rebooting\n11: renaming\n12: stopping\n13: stopped\n14: storage-full\n15: upgrading\n{{/is_alert}}\n{{#is_recovery}}RDS {{ host }} is in **available** state{{/is_recovery}}\n"
}