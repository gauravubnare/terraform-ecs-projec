output "alb_sg" {
    value = aws_security_group.ELB_SG.id
}

output "ecs_sg" {
    value = aws_security_group.ECS_SG.id
}

output "vpc_id" {
    value = aws_vpc.ECS_VPC.id
}

output "subnet01" {
    value = aws_subnet.Public_Subnet01.id
}

output "subnet02" {
    value = aws_subnet.Public_Subnet02.id
}