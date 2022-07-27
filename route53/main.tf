resource "aws_sns_topic" "route53-healthcheck" {
  name      = "route53-healthcheck"
  provisioner "local-exec" {
    command = "aws sns subscribe --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.sns-email}"
  }
}

resource "aws_route53_health_check" "rolax_web_healthcheck" {
  fqdn              = var.domain
  port              = 443
  resource_path     = "/"
  failure_threshold = "3"
  request_interval  = "30"
  measure_latency   = "1"
  search_string     = "installed"
  type              = "HTTPS_STR_MATCH"
  regions = ["us-east-1","us-west-1","us-west-2"]
}