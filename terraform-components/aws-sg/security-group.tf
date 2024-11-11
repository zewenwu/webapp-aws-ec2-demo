resource "aws_security_group" "main" {
  name        = local.security_group_name
  description = var.security_group_description == "" ? "Security group: ${local.security_group_name}" : var.security_group_description
  vpc_id      = var.vpc_id

  tags = merge({
    Name = local.security_group_name
  }, var.tags)
}

### Ingress rules
resource "aws_security_group_rule" "main_ingress_self" {
  description       = "Allow inbound traffic from self security group"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.main.id
}

resource "aws_security_group_rule" "main_ingress_allow_internet" {
  count             = var.allow_ingress_internet ? 1 : 0
  description       = "Allow inbound traffic from internet"
  type              = "ingress"
  from_port         = var.ingress_internet_port
  to_port           = var.ingress_internet_port
  protocol          = var.ingress_internet_protocol
  cidr_blocks       = ["0.0.0.0/0"] #trivy:ignore:avd-aws-0107
  security_group_id = aws_security_group.main.id
}

resource "aws_security_group_rule" "main_allow_from_sg" {
  count                    = length(var.allow_additional_sg_ingress_ids)
  description              = "Allow inbound traffic from additional security group: ${var.allow_additional_sg_ingress_ids[count.index]}"
  type                     = "ingress"
  from_port                = var.additional_sg_port
  to_port                  = var.additional_sg_port
  protocol                 = var.additional_sg_protocol
  source_security_group_id = var.allow_additional_sg_ingress_ids[count.index]
  security_group_id        = aws_security_group.main.id
}

### Egress rules
resource "aws_security_group_rule" "main_egress_internet" {
  description       = "Allow outbound traffic to internet"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"] #trivy:ignore:avd-aws-0104
  security_group_id = aws_security_group.main.id
}
