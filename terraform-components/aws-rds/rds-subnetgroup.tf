resource "aws_db_subnet_group" "main" {
  name       = local.instance_subnetgroup_name
  subnet_ids = var.db_instance_info.subnet_ids

  tags = var.tags
}
