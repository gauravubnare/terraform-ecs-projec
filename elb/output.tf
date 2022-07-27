output "tg_arn" {
  value = aws_lb_target_group.Rolax-Target-Group.arn
}

output "alb_dns_name" {
  value = aws_lb.rolax-alb.dns_name
}