resource "aws_vpc" "main" {
    cidr_block = var.cidr_vpc
   tags = {
     "Name" = "main1"
   }
  }
  resource "aws_subnet" "subs" {
    count = length(var.sub_name)
    vpc_id = aws_vpc.main.id
    cidr_block = var.cide_subnet[count.index]
    tags = {
      "Name" = var.sub_name[count.index]
    }
  }