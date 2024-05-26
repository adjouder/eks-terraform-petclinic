############ Monitoring with CloudWatch ##################

resource "aws_cloudwatch_dashboard" "petclinic-dashboard" {
  dashboard_name = "petclinic-dashboard"
  dashboard_body = jsonencode({
    "widgets": [
      {
        "height": 6,
        "width": 6,
        "y": 0,
        "x": 0,
        "type": "metric",
        "properties": {
          "legend": {
            "position": "bottom"
          },
          "liveData": false,
          "metrics": [
            [ "AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", "vet-db", { "period": 300, "stat": "Sum" } ],
            [ "AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", "visit-db", { "period": 300, "stat": "Sum" } ],
            [ "AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", "customer-db", { "period": 300, "stat": "Sum" } ]
          ],
          "region": "eu-west-3",
          "stacked": false,
          "timezone": "UTC",
          "title": "DatabaseConnections: Sum",
          "view": "timeSeries"
        }
      },
      {
        "height": 6,
        "width": 6,
        "y": 0,
        "x": 6,
        "type": "metric",
        "properties": {
          "annotations": {
            "alarms": [
              "arn:aws:cloudwatch:eu-west-3:957507561258:alarm:eks-memory-alarm"
            ]
          },
          "liveData": false,
          "region": "eu-west-3",
          "stacked": false,
          "timezone": "UTC",
          "title": "eks-memory-alarm",
          "view": "timeSeries"
        }
      },
      {
        "height": 6,
        "width": 6,
        "y": 0,
        "x": 12,
        "type": "metric",
        "properties": {
          "legend": {
            "position": "bottom"
          },
          "liveData": false,
          "metrics": [
            [ "AWS/SNS", "NumberOfNotificationsFailed", "TopicName", "eks-notifications", { "period": 300, "region": "eu-west-3", "stat": "Sum" } ]
          ],
          "region": "eu-west-3",
          "stacked": false,
          "title": "NumberOfNotificationsFailed: Sum",
          "view": "timeSeries"
        }
      },
      {
        "height": 6,
        "width": 6,
        "y": 6,
        "x": 12,
        "type": "metric",
        "properties": {
          "legend": {
            "position": "bottom"
          },
          "liveData": false,
          "metrics": [
            [ "AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", "vet-db", { "period": 300, "region": "eu-west-3", "stat": "Sum" } ],
            [ "...", "visit-db", { "period": 300, "region": "eu-west-3", "stat": "Sum" } ],
            [ "...", "customer-db", { "period": 300, "region": "eu-west-3", "stat": "Sum" } ]
          ],
          "region": "eu-west-3",
          "stacked": false,
          "title": "DatabaseConnections: Sum",
          "view": "timeSeries"
        }
      },
      {
        "height": 6,
        "width": 6,
        "y": 6,
        "x": 6,
        "type": "metric",
        "properties": {
          "annotations": {
            "alarms": [
              "arn:aws:cloudwatch:eu-west-3:957507561258:alarm:ApplicationInsights/ApplicationInsights-customer-db/AWS/RDS/WriteLatency/vet-db/"
            ]
          },
          "stacked": false,
          "title": "ApplicationInsights/ApplicationInsights-customer-db/AWS/RDS/WriteLatency/vet-db/",
          "view": "timeSeries"
        }
      },
      {
        "height": 6,
        "width": 6,
        "y": 0,
        "x": 18,
        "type": "metric",
        "properties": {
          "title": "D-Customer-free-data-storage",
          "annotations": {
            "alarms": [
              "arn:aws:cloudwatch:eu-west-3:957507561258:alarm:D-Customer-free-data-storage"
            ]
          },
          "liveData": false,
          "region": "eu-west-3",
          "timezone": "UTC",
          "view": "timeSeries",
          "stacked": false
        }
      },
      {
        "height": 6,
        "width": 6,
        "y": 6,
        "x": 0,
        "type": "metric",
        "properties": {
          "title": "EC2-Check-Status-alarm",
          "annotations": {
            "alarms": [
              "arn:aws:cloudwatch:eu-west-3:957507561258:alarm:EC2-Check-Status-alarm"
            ]
          },
          "liveData": false,
          "region": "eu-west-3",
          "timezone": "UTC",
          "view": "timeSeries",
          "stacked": false
        }
      },
      {
        "type": "metric",
        "x": 18,
        "y": 6,
        "width": 6,
        "height": 6,
        "properties": {
          "region": "eu-west-3",
          "title": "EKS Landing Page Control Plane Widget Total Server Requests",
          "legend": {
            "position": "bottom"
          },
          "timezone": "LOCAL",
          "metrics": [
            [ { "id": "expr1", "color": "#1f77b4", "label": "Max API server requests", "expression": "SELECT MAX(apiserver_request_total) FROM SCHEMA(ContainerInsights, ClusterName) " } ]
          ],
          "liveData": false,
          "period": 60,
          "view": "singleValue",
          "sparkline": true,
          "yAxis": {
            "left": {
              "showUnits": false,
              "label": "Percent"
            }
          }
        }
      },
      {
        "type": "metric",
        "x": 0,
        "y": 12,
        "width": 6,
        "height": 6,
        "properties": {
          "region": "eu-west-3",
          "title": "EKS Landing Page Control Plane Widget Server Request Latency",
          "legend": {
            "position": "bottom"
          },
          "timezone": "LOCAL",
          "metrics": [
            [ { "id": "expr1", "color": "#1f77b4", "label": "Average API server requests latency", "expression": "SELECT AVG(apiserver_request_duration_seconds) FROM SCHEMA(ContainerInsights, ClusterName) " } ]
          ],
          "liveData": false,
          "period": 60,
          "view": "singleValue",
          "sparkline": true,
          "yAxis": {
            "left": {
              "showUnits": false,
              "label": "Percent"
            }
          }
        }
      },
      {
        "type": "metric",
        "x": 6,
        "y": 12,
        "width": 6,
        "height": 6,
        "properties": {
          "region": "eu-west-3",
          "title": "EKS Landing Page Control Plane Widget Total Number Of Stored Objects",
          "legend": {
            "position": "bottom"
          },
          "timezone": "LOCAL",
          "metrics": [
            [ { "id": "expr1", "color": "#1f77b4", "label": "Total number of stored objects", "expression": "SELECT MAX(apiserver_storage_objects) FROM SCHEMA(ContainerInsights, ClusterName) " } ]
          ],
          "liveData": false,
          "period": 60,
          "view": "singleValue",
          "sparkline": true,
          "yAxis": {
            "left": {
              "showUnits": false,
              "label": "Percent"
            }
          }
        }
      },
      {
        "type": "metric",
        "x": 12,
        "y": 12,
        "width": 6,
        "height": 6,
        "properties": {
          "region": "eu-west-3",
          "title": "EKS Landing Page Control Plane Widget Admission Controller Latency",
          "legend": {
            "position": "bottom"
          },
          "timezone": "LOCAL",
          "metrics": [
            [ { "id": "expr1", "color": "#1f77b4", "label": "Average admission controller latency", "expression": "SELECT AVG(apiserver_admission_controller_admission_duration_seconds) FROM SCHEMA(ContainerInsights, ClusterName) " } ]
          ],
          "liveData": false,
          "period": 60,
          "view": "singleValue",
          "sparkline": true,
          "yAxis": {
            "left": {
              "showUnits": false,
              "label": "Percent"
            }
          }
        }
      },
      {
        "type": "metric",
        "x": 18,
        "y": 12,
        "width": 6,
        "height": 6,
        "properties": {
          "region": "eu-west-3",
          "title": "Top Pods per Memory Utilization",
          "legend": {
            "position": "right"
          },
          "timezone": "LOCAL",
          "metrics": [
            [ { "expression": "SELECT MAX(pod_memory_utilization) FROM SCHEMA(ContainerInsights, ClusterName, FullPodName, Namespace, PodName)  GROUP BY FullPodName,PodName,Namespace,ClusterName ORDER BY MAX() DESC LIMIT 10" } ]
          ],
          "liveData": false,
          "period": 60,
          "yAxis": {
            "left": {
              "min": 0,
              "showUnits": false,
              "label": "Percent"
            }
          }
        }
      },
      {
        "type": "metric",
        "x": 0,
        "y": 18,
        "width": 6,
        "height": 6,
        "properties": {
          "region": "eu-west-3",
          "title": "Top Containers per Memory Utilization",
          "legend": {
            "position": "right"
          },
          "timezone": "LOCAL",
          "metrics": [
            [ { "expression": "SELECT MAX(container_memory_utilization) FROM SCHEMA(ContainerInsights, ClusterName, Namespace, PodName, FullPodName, ContainerName)  GROUP BY ContainerName,FullPodName,PodName,Namespace,ClusterName ORDER BY MAX() DESC LIMIT 10" } ]
          ],
          "liveData": false,
          "period": 60,
          "yAxis": {
            "left": {
              "min": 0,
              "showUnits": false,
              "label": "Percent"
            }
          }
        }
      }
    ]
  })
}


resource "aws_cloudwatch_log_group" "eks_logs" {
  name              = "${var.cluster_name}-eks-logs-group"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_stream" "eks_log_stream" {
  name           = "${var.cluster_name}-eks-logs-stream"
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
  endpoint  = "it.abdenour.djouder@gamil.com"
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